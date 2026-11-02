export const PRODUCT_IDS = new Set([
  "fitcheck_premium_monthly",
  "fitcheck_premium_yearly",
]);

export type PlaySubscriptionLineItem = {
  productId?: string | null;
  expiryTime?: string | null;
};

export type PlaySubscription = {
  subscriptionState?: string | null;
  lineItems?: PlaySubscriptionLineItem[] | null;
  externalAccountIdentifiers?: {
    obfuscatedExternalAccountId?: string | null;
  } | null;
};

const ENTITLED_STATES = new Set([
  "SUBSCRIPTION_STATE_ACTIVE",
  "SUBSCRIPTION_STATE_IN_GRACE_PERIOD",
  // Cancelled subscriptions remain entitled until their paid-through expiry.
  "SUBSCRIPTION_STATE_CANCELED",
]);

export function isKnownProduct(productId: unknown): productId is string {
  return typeof productId === "string" && PRODUCT_IDS.has(productId);
}

export function evaluatePlaySubscription(
  subscription: PlaySubscription,
  expectedProductId: string,
  nowMs = Date.now(),
): { active: boolean; expiresAt: string | null } {
  if (!isKnownProduct(expectedProductId)) {
    return { active: false, expiresAt: null };
  }

  const matchingItems = (subscription.lineItems ?? []).filter(
    (item) => item.productId === expectedProductId,
  );
  const expiries = matchingItems
    .map((item) => item.expiryTime ?? null)
    .filter((value): value is string => value !== null)
    .map((value) => ({ value, ms: Date.parse(value) }))
    .filter((value) => Number.isFinite(value.ms));

  const latest = expiries.sort((a, b) => b.ms - a.ms)[0];
  const active =
    ENTITLED_STATES.has(subscription.subscriptionState ?? "") &&
    latest !== undefined &&
    latest.ms > nowMs;

  return { active, expiresAt: latest?.value ?? null };
}
