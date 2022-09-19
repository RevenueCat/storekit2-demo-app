//
//  Step10PurchaseManager.swift
//  StoreKitPlayground (iOS)
//
//  Created by Josh Holtz on 9/18/22.
//

import Foundation
import StoreKit

@MainActor
class Step10PurchaseManager: NSObject, ObservableObject {

    let productIds = ["pro_monthly", "pro_yearly", "pro_lifetime"]

    @Published var products: [Product] = []
    @Published var purchasedProductIDs = Set<String>()

    let entitlementManager: Step10EntitlementManager

    init(entitlementManager: Step10EntitlementManager) {
        self.entitlementManager = entitlementManager
        super.init()
        SKPaymentQueue.default().add(self)
        Task {
            try await loadProducts()
            await updatePurchasedProducts()
        }
    }

    func loadProducts() async throws {
        let products = try await Product.products(for: productIds)

        // Products are not returned in the order the ids are requested
        // Sorting the products based on productIds index
        self.products = products.sorted { (a, b) in
            guard let indexA = self.productIds.firstIndex(of: a.id), let indexB = self.productIds.firstIndex(of: b.id) else {
                return false
            }
            return indexA < indexB
        }
    }

    func purchase(product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case .success(let verificationResult):
            switch verificationResult {
            case .verified(let transaction):
                await transaction.finish()
                await self.updatePurchasedProducts()
            case .unverified:
                break
            }
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }

        self.entitlementManager.hasPro = self.purchasedProductIDs.count > 0
    }
}

extension Step10PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

    }

    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
