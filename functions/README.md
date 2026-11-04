# FitCheck Firebase Functions

Functions region: `europe-west1`.
Runtime: Node.js 22.

## Play subscription verification setup

`verifySubscription` and `getSubscriptionEntitlement` use the function's Google
Cloud service identity to call the Google Play Developer API. Before deployment:

1. Enable the Google Play Android Developer API in the Google Cloud project
   `fitcheck-98dec`.
2. Grant the Cloud Functions runtime service account permission to use the API.
3. Add that service account in Play Console > Users and permissions and grant
   access to the FitCheck app and subscription/order data.
4. Confirm both product IDs in `src/entitlement.ts` exactly match Play Console.
5. Install dependencies and run `npm test` from this directory.
6. Deploy only after reviewing the rules and function code:
   `firebase deploy --project fitcheck-98dec --only firestore:rules,functions`.

The client sends the Google Play purchase token only to this authenticated
callable function and includes a SHA-256 account binding in the billing flow.
Tokens are stored in the server-only `purchaseClaims` collection so active
entitlements can be rechecked on later launches. Firestore rules deny all client
access to that collection. The `deleteAccount` callable requires recent sign-in,
removes the profile and purchase records, then deletes the Auth user; it restores
the Firestore records if Auth deletion fails.

Apple App Store receipt/JWS verification is intentionally not enabled here.
Do not enable iOS purchases until an Apple server-verification implementation
and its App Store Connect configuration are added and tested.
