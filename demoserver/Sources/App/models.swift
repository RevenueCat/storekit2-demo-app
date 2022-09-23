import Foundation
import JWT

struct SignedPayload: Decodable {
    let signedPayload: String
}

enum NotificationType: String, Codable {
    case consumptionRequest = "CONSUMPTION_REQUEST"
    case didChangeRenewalPref = "DID_CHANGE_RENEWAL_PREF"
    case didChangeRenewalStatus = "DID_CHANGE_RENEWAL_STATUS"
    case didfailToRenew = "DID_FAIL_TO_RENEW"
    case didRenew = "DID_RENEW"
    case expired = "EXPIRED"
    case gradePeriodExpired = "GRACE_PERIOD_EXPIRED"
    case offeredRedeemed = "OFFER_REDEEMED"
    case priceIncrease = "PRICE_INCREASE"
    case refund = "REFUND"
    case refundDeclined = "REFUND_DECLINED"
    case renewalExtended = "RENEWAL_EXTENDED"
    case revoke = "REVOKE"
    case subscribed = "SUBSCRIBED"
    case test = "TEST"
}

enum NotificationSubtype: String, Codable {
    case initialBuy = "INITIAL_BUY"
    case resubscribe = "RESUBSCRIBE"
    case downgrade = "DOWNGRADE"
    case upgrade = "UPGRADE"
    case autoRenewEnabled = "AUTO_RENEW_ENABLED"
    case autoRenewDisabled = "AUTO_RENEW_DISABLED"
    case voluntary = "VOLUNTARY"
    case billingRetry = "BILLING_RETRY"
    case priceIncrease = "PRICE_INCREASE"
    case gracePeriod = "GRACE_PERIOD"
    case billingRecovery = "BILLING_RECOVERY"
    case pending = "PENDING"
    case accepted = "ACCEPTED"
}

struct NotificationData: Codable {
    let appAppleId: String?
    let bundleId: String
    let bundleVersion: String?
    let environment: Environment
    let signedRenewalInfo: String?
    let signedTransactionInfo: String?

    // Signed renewal info
    // https://developer.apple.com/documentation/appstoreservernotifications/jwsrenewalinfodecodedpayload

    // Signed transaction info
    // https://developer.apple.com/documentation/appstoreservernotifications/jwstransactiondecodedpayload
}

enum Environment: String, Codable {
    case sandbox = "Sandbox"
    case production = "Production"
}

struct NotificationPayload: JWTPayload {
    let notificationType: NotificationType
    let notificatonSubtype: NotificationSubtype?
    let notificationUUID: String
    let data: NotificationData
    let version: String
    let signedDate: Int

    func verify(using signer: JWTSigner) throws {
    }
}
