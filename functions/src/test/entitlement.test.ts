import assert from "node:assert/strict";
import test from "node:test";

import { evaluatePlaySubscription, isKnownProduct } from "../entitlement";

const NOW = Date.parse("2026-11-02T12:00:00.000Z");

test("accepts active subscription through paid expiry", () => {
  const result = evaluatePlaySubscription(
    {
      subscriptionState: "SUBSCRIPTION_STATE_ACTIVE",
      lineItems: [
        {
          productId: "fitcheck_premium_monthly",
          expiryTime: "2026-12-02T12:00:00.000Z",
        },
      ],
    },
    "fitcheck_premium_monthly",
    NOW,
  );
  assert.equal(result.active, true);
});

test("keeps canceled subscription active until paid expiry", () => {
  const result = evaluatePlaySubscription(
    {
      subscriptionState: "SUBSCRIPTION_STATE_CANCELED",
      lineItems: [
        {
          productId: "fitcheck_premium_yearly",
          expiryTime: "2026-12-02T12:00:00.000Z",
        },
      ],
    },
    "fitcheck_premium_yearly",
    NOW,
  );
  assert.equal(result.active, true);
});

test("rejects expired subscriptions and product mismatches", () => {
  const expired = evaluatePlaySubscription(
    {
      subscriptionState: "SUBSCRIPTION_STATE_EXPIRED",
      lineItems: [
        {
          productId: "fitcheck_premium_monthly",
          expiryTime: "2026-11-01T12:00:00.000Z",
        },
      ],
    },
    "fitcheck_premium_monthly",
    NOW,
  );
  const mismatch = evaluatePlaySubscription(
    {
      subscriptionState: "SUBSCRIPTION_STATE_ACTIVE",
      lineItems: [
        {
          productId: "other_product",
          expiryTime: "2026-12-02T12:00:00.000Z",
        },
      ],
    },
    "fitcheck_premium_monthly",
    NOW,
  );
  assert.equal(expired.active, false);
  assert.equal(mismatch.active, false);
});

test("accepts only the configured product IDs", () => {
  assert.equal(isKnownProduct("fitcheck_premium_monthly"), true);
  assert.equal(isKnownProduct("fitcheck_premium_yearly"), true);
  assert.equal(isKnownProduct("premium_forever"), false);
});
