//
//  Step1View.swift
//  StoreKitPlayground
//
//  Created by Josh Holtz on 9/1/22.
//

import SwiftUI
import StoreKit

// THOUGHTS
// 1. Loading products super easy
// 2. Calling purchase seems super easy
//   - Successfully made a purchase in a few minutes
// 3. Now a little overwhelmed with purchase result type of:
//   - success (verified)
//   - success (unverified)
//   - pending
//   - user cancelled
// 4. I'm getting a purple warning about listening to Transaction.updates
// 5. Found example of TransactionObserver to copy from
//   - https://developer.apple.com/documentation/storekit/transaction/3851206-updates
// 6. Discovered I can get purchase state with `await product.currentEntitlement`
//   - It's an async call so had to do a weird sync asyc iteration to get it (probably more efficient way)
// 7. Oops on #6 - `Transaction.currentEntitlements` feels better to use
// 8. Looks like `AppStore.sync()` can be used to restore purchases but isn't actually needed
// 9. Its really nice that I don't need to worry about parsing receipt locally at all

struct Step1View: View {
    let productIds = [
        "com.revenuecat.sk2blog.monthly",
        "com.revenuecat.sk2blog.yearly"
    ]

    @State var products: [Product] = []
    @State var purchasedProductIds = Set<String>()

    var body: some View {
        VStack(spacing: 20) {
            ForEach(self.products) { (product) in
                Button {
                    Task {
                        await self.purchaseProduct(product: product)
                        await self.updatePurchases()
                    }
                } label: {
                    Text("\(product.displayPrice) - \(product.displayName)")
                }.disabled(self.purchasedProductIds.contains(product.id))
            }

            Divider()

            // This actually isn't really needed
            Button {
                Task {
                    do {
                        try await AppStore.sync()
                    } catch {
                        print("Sync error")
                    }
                }
            } label: {
                Text("Restore Purchases")
            }

        }.task {
            await self.loadProducts()
        }
    }

    func updatePurchases() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }

            if transaction.revocationDate == nil {
                self.purchasedProductIds.insert(transaction.productID)
            } else {
                self.purchasedProductIds.remove(transaction.productID)
            }
        }
    }

    private func loadProducts() async {
        do {
            self.products = try await Product.products(for: productIds)
            await self.updatePurchases()
        } catch {
            print("Error loading products: \(error)")
        }
    }

    private func purchaseProduct(product: Product) async {
        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verificationResult):
                switch verificationResult {
                case .verified(let transaction):
                    await transaction.finish()
                case .unverified:
                    // Not a valid purchase
                    // Maybe show user an error
                    break
                }
            case .pending:
                // The purchase requires action from the customer with SCA (Strong Customer Authentication) or Ask to Buy
                // If the transaction completes,
                // it's available through Transaction.updates.
                break
            case .userCancelled:
                // The user canceled the purchase.
                break
            @unknown default:
                break
            }
        } catch {
            print("Error purchasing product: \(error)")
        }
    }
}
