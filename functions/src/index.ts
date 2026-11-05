import { createHash } from "node:crypto";
import { getApps, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import {
  FieldValue,
  Timestamp,
  getFirestore,
} from "firebase-admin/firestore";
import { GoogleAuth } from "google-auth-library";
import jwt from "jsonwebtoken";
import { setGlobalOptions } from "firebase-functions/v2";
import { HttpsError, onCall } from "firebase-functions/v2/https";

import {
  evaluatePlaySubscription,
  isKnownProduct,
  PlaySubscription,
} from "./entitlement";

if (getApps().length === 0) initializeApp();

setGlobalOptions({
  region: "europe-west1",
  timeoutSeconds: 60,
  memory: "256MiB",
  maxInstances: 10,
});

const PACKAGE_NAME = "com.fitcheck2.app";
const db = getFirestore();

type VerifiedPlayPurchase = {
  active: boolean;
  expiresAt: string | null;
};

async function verifyWithGooglePlay(
  purchaseToken: string,
  productId: string,
  uid: string,
): Promise<VerifiedPlayPurchase> {
  const auth = new GoogleAuth({
    scopes: ["https://www.googleapis.com/auth/androidpublisher"],
  });
  const client = await auth.getClient();
  const accessToken = await client.getAccessToken();
  if (!accessToken.token) {
    console.error("Play API access token is missing.");
    throw new HttpsError("unavailable", "Play API authentication is unavailable.");
  }

  const url = new URL(
    `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${encodeURIComponent(PACKAGE_NAME)}/purchases/subscriptionsv2/tokens/${encodeURIComponent(purchaseToken)}`,
  );
  const response = await fetch(url, {
    headers: { Authorization: `Bearer ${accessToken.token}` },
  });
  if (!response.ok) {
    const errorBody = (await response.text().catch(() => "")).slice(0, 800);
    console.error("Google Play verification request failed.", {
      status: response.status,
      body: errorBody,
    });
    if (response.status === 404) {
      throw new HttpsError("permission-denied", "Purchase token was not found.");
    }
    throw new HttpsError("unavailable", "Google Play verification is unavailable.");
  }
  const subscription = (await response.json()) as PlaySubscription;

  const linkedAccount =
    subscription.externalAccountIdentifiers?.obfuscatedExternalAccountId;
  const expectedAccount = createHash("sha256").update(uid).digest("hex");
  if (linkedAccount && linkedAccount !== expectedAccount) {
    throw new HttpsError(
      "permission-denied",
      "Purchase account does not match the signed-in account.",
    );
  }

  if (!(subscription.lineItems ?? []).some((item) => item.productId === productId)) {
    throw new HttpsError("permission-denied", "Purchase product did not match.");
  }

  return evaluatePlaySubscription(subscription, productId);
}

function requireCaller(uid: string | undefined): string {
  if (!uid) throw new HttpsError("unauthenticated", "Sign in is required.");
  return uid;
}

function purchaseClaimId(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}

function requirePlayRequest(data: unknown): {
  productId: string;
  purchaseToken: string;
} {
  if (!data || typeof data !== "object") {
    throw new HttpsError("invalid-argument", "Invalid purchase data.");
  }
  const request = data as Record<string, unknown>;
  if (request.store !== "google_play") {
    throw new HttpsError(
      "failed-precondition",
      "This store is not configured for server verification.",
    );
  }
  if (!isKnownProduct(request.productId)) {
    throw new HttpsError("invalid-argument", "Unknown subscription product.");
  }
  if (
    typeof request.purchaseToken !== "string" ||
    request.purchaseToken.length < 20 ||
    request.purchaseToken.length > 8192
  ) {
    throw new HttpsError("invalid-argument", "Invalid purchase token.");
  }
  return {
    productId: request.productId,
    purchaseToken: request.purchaseToken,
  };
}

async function claimPurchase(
  uid: string,
  productId: string,
  purchaseToken: string,
  result: VerifiedPlayPurchase,
): Promise<void> {
  const ref = db.collection("purchaseClaims").doc(purchaseClaimId(purchaseToken));
  await db.runTransaction(async (transaction) => {
    const existing = await transaction.get(ref);
    const oldOwner = existing.data()?.uid;
    if (oldOwner && oldOwner !== uid) {
      throw new HttpsError(
        "permission-denied",
        "This purchase is linked to another account.",
      );
    }

    transaction.set(
      ref,
      {
        uid,
        productId,
        purchaseToken,
        store: "google_play",
        active: result.active,
        expiresAt: result.expiresAt
          ? Timestamp.fromDate(new Date(result.expiresAt))
          : null,
        verifiedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
  });
}

async function verifyAndClaim(
  uid: string,
  productId: string,
  purchaseToken: string,
): Promise<VerifiedPlayPurchase> {
  try {
    const result = await verifyWithGooglePlay(purchaseToken, productId, uid);
    await claimPurchase(uid, productId, purchaseToken, result);
    return result;
  } catch (error) {
    if (error instanceof HttpsError) {
      console.error("Google Play verification rejected.", {
        code: error.code,
        message: error.message,
      });
      throw error;
    }
    // Do not log purchase tokens or provider request details.
    console.error("Google Play purchase verification failed.", {
      name: error instanceof Error ? error.name : typeof error,
      message: error instanceof Error ? error.message : String(error),
    });
    throw new HttpsError(
      "unavailable",
      "Purchase verification is temporarily unavailable.",
    );
  }
}

export const verifySubscription = onCall(async (request) => {
  const uid = requireCaller(request.auth?.uid);
  const { productId, purchaseToken } = requirePlayRequest(request.data);
  const result = await verifyAndClaim(uid, productId, purchaseToken);
  return { verified: true, active: result.active, expiresAt: result.expiresAt };
});

export const getSubscriptionEntitlement = onCall(async (request) => {
  const uid = requireCaller(request.auth?.uid);
  const claims = await db
    .collection("purchaseClaims")
    .where("uid", "==", uid)
    .limit(20)
    .get();

  if (claims.empty) return { known: false, active: false };

  let active = false;
  for (const claim of claims.docs) {
    const data = claim.data();
    if (
      data.store !== "google_play" ||
      !isKnownProduct(data.productId) ||
      typeof data.purchaseToken !== "string"
    ) {
      continue;
    }
    const result = await verifyAndClaim(uid, data.productId, data.purchaseToken);
    active ||= result.active;
  }
  return { known: true, active };
});

const APPLE_CLIENT_ID = process.env.APPLE_CLIENT_ID ?? "com.fitcheck2.app";
const APPLE_TEAM_ID = process.env.APPLE_TEAM_ID ?? "";
const APPLE_KEY_ID = process.env.APPLE_KEY_ID ?? "";
const APPLE_PRIVATE_KEY = process.env.APPLE_PRIVATE_KEY_BASE64
  ? Buffer.from(process.env.APPLE_PRIVATE_KEY_BASE64, "base64").toString("utf8")
  : (process.env.APPLE_PRIVATE_KEY ?? "").replace(/\\n/g, "\n");

function appleConfigured(): boolean {
  return Boolean(APPLE_TEAM_ID && APPLE_KEY_ID && APPLE_PRIVATE_KEY);
}

function appleClientSecret(): string {
  return jwt.sign({}, APPLE_PRIVATE_KEY, {
    algorithm: "ES256",
    expiresIn: "5m",
    audience: "https://appleid.apple.com",
    issuer: APPLE_TEAM_ID,
    subject: APPLE_CLIENT_ID,
    keyid: APPLE_KEY_ID,
  });
}

async function revokeAppleToken(refreshToken: string): Promise<void> {
  const response = await fetch("https://appleid.apple.com/auth/revoke", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      token: refreshToken,
      client_id: APPLE_CLIENT_ID,
      client_secret: appleClientSecret(),
      token_type_hint: "refresh_token",
    }),
  });
  if (!response.ok) {
    // Token zaten geçersiz olabilir; hesap silmeyi engelleme.
    console.warn("Apple token revocation was not confirmed.");
  }
}

export const storeAppleToken = onCall(async (request) => {
  const uid = requireCaller(request.auth?.uid);
  const code = (request.data as { code?: unknown } | null)?.code;
  if (typeof code !== "string" || code.length < 10 || code.length > 4096) {
    throw new HttpsError("invalid-argument", "Invalid Apple authorization code.");
  }
  if (!appleConfigured()) {
    throw new HttpsError(
      "failed-precondition",
      "Apple token storage is not configured.",
    );
  }

  const response = await fetch("https://appleid.apple.com/auth/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "authorization_code",
      code,
      client_id: APPLE_CLIENT_ID,
      client_secret: appleClientSecret(),
    }),
  });
  if (!response.ok) {
    throw new HttpsError("unavailable", "Apple token exchange failed.");
  }
  const data = (await response.json()) as { refresh_token?: string };
  if (!data.refresh_token) {
    throw new HttpsError("unavailable", "Apple refresh token was not returned.");
  }

  await db.collection("appleTokens").doc(uid).set(
    {
      uid,
      refreshToken: data.refresh_token,
      updatedAt: FieldValue.serverTimestamp(),
    },
    { merge: true },
  );
  return { stored: true };
});

export const deleteAccount = onCall(async (request) => {
  const uid = requireCaller(request.auth?.uid);
  const authTime = request.auth?.token.auth_time;
  const firebaseClaims = request.auth?.token.firebase as
    | { sign_in_provider?: string }
    | undefined;
  const anonymousSession = firebaseClaims?.sign_in_provider === "anonymous";
  if (
    !anonymousSession &&
    (typeof authTime !== "number" || Date.now() / 1000 - authTime > 5 * 60)
  ) {
    throw new HttpsError(
      "failed-precondition",
      "Please sign in again before deleting your account.",
    );
  }

  const profileRef = db.collection("kullanicilar").doc(uid);
  const profileSnapshot = await profileRef.get();
  const claimsSnapshot = await db
    .collection("purchaseClaims")
    .where("uid", "==", uid)
    .limit(401)
    .get();
  if (claimsSnapshot.size > 400) {
    throw new HttpsError(
      "failed-precondition",
      "Too many purchase records to delete in one request.",
    );
  }

  const appleTokenRef = db.collection("appleTokens").doc(uid);
  const appleTokenSnapshot = await appleTokenRef.get();
  const appleRefreshToken = appleTokenSnapshot.data()?.refreshToken;
  if (
    typeof appleRefreshToken === "string" &&
    appleRefreshToken.length > 0 &&
    appleConfigured()
  ) {
    try {
      await revokeAppleToken(appleRefreshToken);
    } catch (error) {
      console.warn("Apple token revocation failed; continuing deletion.");
    }
  }

  try {
    if (profileSnapshot.exists) await profileRef.delete();
    if (!claimsSnapshot.empty || appleTokenSnapshot.exists) {
      const batch = db.batch();
      for (const claim of claimsSnapshot.docs) batch.delete(claim.ref);
      if (appleTokenSnapshot.exists) batch.delete(appleTokenRef);
      await batch.commit();
    }
    await getAuth().deleteUser(uid);
    return { deleted: true };
  } catch (error) {
    // Auth silme başarısız olduysa profili ve entitlement kayıtlarını geri koy;
    // kullanıcı yarım silinmiş hesapla bırakılmasın.
    try {
      if (
        profileSnapshot.exists ||
        !claimsSnapshot.empty ||
        appleTokenSnapshot.exists
      ) {
        const restore = db.batch();
        if (profileSnapshot.exists) {
          restore.set(profileRef, profileSnapshot.data()!);
        }
        for (const claim of claimsSnapshot.docs) {
          restore.set(claim.ref, claim.data());
        }
        if (appleTokenSnapshot.exists) {
          restore.set(appleTokenRef, appleTokenSnapshot.data()!);
        }
        await restore.commit();
      }
    } catch (restoreError) {
      console.error("Account deletion rollback failed; manual cleanup required.");
    }
    if (error instanceof HttpsError) throw error;
    console.error("Account deletion failed.");
    throw new HttpsError("internal", "Account deletion could not be completed.");
  }
});
