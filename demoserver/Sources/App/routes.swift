import Vapor
import JWT
import JWTKit

let appleRootCert = """
-----BEGIN CERTIFICATE-----
MIICQzCCAcmgAwIBAgIILcX8iNLFS5UwCgYIKoZIzj0EAwMwZzEbMBkGA1UEAwwS
QXBwbGUgUm9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9u
IEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcN
MTQwNDMwMTgxOTA2WhcNMzkwNDMwMTgxOTA2WjBnMRswGQYDVQQDDBJBcHBsZSBS
b290IENBIC0gRzMxJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9y
aXR5MRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUzB2MBAGByqGSM49
AgEGBSuBBAAiA2IABJjpLz1AcqTtkyJygRMc3RCV8cWjTnHcFBbZDuWmBSp3ZHtf
TjjTuxxEtX/1H7YyYl3J6YRbTzBPEVoA/VhYDKX1DyxNB0cTddqXl5dvMVztK517
IDvYuVTZXpmkOlEKMaNCMEAwHQYDVR0OBBYEFLuw3qFYM4iapIqZ3r6966/ayySr
MA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMAoGCCqGSM49BAMDA2gA
MGUCMQCD6cHEFl4aXTQY2e3v9GwOAEZLuN+yRhHFD/3meoyhpmvOwgPUnPWTxnS4
at+qIxUCMG1mihDK1A3UT82NQz60imOlM27jbdoXt2QfyFMm+YhidDkLF1vLUagM
6BgD56KyKA==
-----END CERTIFICATE-----
"""

func routes(_ app: Application) throws {
    app.post("apple/notifications") { req async -> HTTPStatus in
        do {
            let notification = try req.content.decode(SignedPayload.self)
            let x5cVerifier = try X5CVerifier(rootCertificates: [appleRootCert])
            let payload = try x5cVerifier.verifyJWS(
                notification.signedPayload, 
                as: NotificationPayload.self)

            // Add job to process and update transaction
            // Updates user's entitlements (unlocked products or features)
            try await req.queue.dispatch(AppleNotificationJob.self, payload)

            print(payload)

            return .ok
        } catch {
            print(error)
            // For version 2 notifications, it retries five times; at 1, 12, 24, 48, and 72 hours after the previous attempt.
            // https://developer.apple.com/documentation/appstoreservernotifications/responding_to_app_store_server_notifications
            return .badRequest
        }
    }

    app.post("apple/transactions") { req async -> Response in
        do {
            let newTransaction = try req.content.decode(PostTransaction.self)
            let transaction = processTransaction(
                originalTransactionID: newTransaction.originalTransactionId)
            return try await transaction.encodeResponse(for: req)
        } catch {
            return .init(status: .badRequest)
        }
    }
}

func processTransaction(originalTransactionID: String) -> Transaction {
    return Transaction(transactionId: "")
}

struct PostTransaction: Codable {
    let originalTransactionId: String
}

struct Transaction {
    let transactionId: String
}

extension Transaction: AsyncResponseEncodable {
    func encodeResponse(for request: Request) async throws -> Response {
        var headers = HTTPHeaders()
            headers.add(name: .contentType, value: "application/json")
        return .init(status: .ok, headers: headers, body: .init(string: ""))
    }
}

/*
 * Potentially do some lookup with history if notifiations were missed
 * https://developer.apple.com/documentation/appstoreserverapi/get_notification_history
 *
 * Get transaction history
 * https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history
 *
 * Get all subscription status
 * https://developer.apple.com/documentation/appstoreserverapi/get_all_subscription_statuses
 *
 * Get refund history
 * https://developer.apple.com/documentation/appstoreserverapi/get_refund_history
 *
 * Extend subscription renewal
 * https://developer.apple.com/documentation/appstoreserverapi/extend_a_subscription_renewal_date
 */
