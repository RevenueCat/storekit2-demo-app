//
//  Step7ContentView.swift
//  StoreKitPlayground (iOS)
//
//  Created by Josh Holtz on 9/17/22.
//

import SwiftUI
import StoreKit

struct Step7ContentView: View {
    @StateObject var entitlementManager: Step7EntitlementManager
    @StateObject var purchaseManager: Step7PurchaseManager

    init() {
        let entitlementManager = Step7EntitlementManager()
        let purchaseManager = Step7PurchaseManager(entitlementManager: entitlementManager)
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._purchaseManager = StateObject(wrappedValue: purchaseManager)
    }

    var body: some View {
        VStack(spacing: 20) {
            if entitlementManager.hasPro {
                Text("Thank you for purchasing pro!")
            } else {
                Text("Products")
                ForEach(purchaseManager.products) { (product) in
                    Button {
                        Task {
                            do {
                                try await purchaseManager.purchase(product: product)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("\(product.displayPrice) - \(product.displayName)")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Capsule())
                    }
                }

                Button {
                    Task {
                        do {
                            try await AppStore.sync()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Restore Purchases")
                }
            }
        }
    }
}
