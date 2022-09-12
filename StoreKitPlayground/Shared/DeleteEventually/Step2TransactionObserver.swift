//
//  Step2TransactionObserver.swift
//  StoreKitPlayground
//
//  Created by Josh Holtz on 9/1/22.
//

import Foundation
import StoreKit

// THOUGHTS
// 1. Took this example from
//   - https://developer.apple.com/documentation/storekit/transaction/3851206-updates
// 2. It is a little intimidating but it kind of a nice template
// 3. Found a note in the docs saying `For more information about finishing transactions, see finish().`
//   - Not really sure what it wants me to do with `finish()` yet

final class TransactionObserver {

    var updates: Task<Void, Never>? = nil

    init() {
        updates = newTransactionListenerTask()
    }

    deinit {
        // Cancel the update handling task when you deinitialize the class.
        updates?.cancel()
    }

    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                self.handle(updatedTransaction: verificationResult)
            }
        }
    }

    private func handle(updatedTransaction verificationResult: VerificationResult<Transaction>) {
        guard case .verified(let transaction) = verificationResult else {
            // Ignore unverified transactions.
            return
        }

        if let revocationDate = transaction.revocationDate {
            // Remove access to the product identified by transaction.productID.
            // Transaction.revocationReason provides details about
            // the revoked transaction.
            return
        } else if let expirationDate = transaction.expirationDate,
            expirationDate < Date() {
            // Do nothing, this subscription is expired.
            return
        } else if transaction.isUpgraded {
            // Do nothing, there is an active transaction
            // for a higher level of service.
            return
        } else {
            // Provide access to the product identified by
            // transaction.productID.
            return
        }
    }

}
