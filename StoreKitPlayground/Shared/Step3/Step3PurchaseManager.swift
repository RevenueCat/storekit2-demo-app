//
//  Step3PurchaseManager.swift
//  StoreKitPlayground (iOS)
//
//  Created by Josh Holtz on 9/11/22.
//

import Foundation
import StoreKit

@MainActor
class Step3PurchaseManager: ObservableObject {

    let productIds = ["pro_monthly", "pro_yearly", "pro_lifetime"]

    @Published var products: [Product] = []

    init() {
        Task {
            try await loadProducts()
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
}
