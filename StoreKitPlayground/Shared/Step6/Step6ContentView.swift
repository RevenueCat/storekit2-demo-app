//
//  Step6ContentView.swift
//  StoreKitPlayground (iOS)
//
//  Created by Josh Holtz on 9/17/22.
//

import SwiftUI
import StoreKit

struct Step6ContentView: View {
    @StateObject var purchaseManager = Step6PurchaseManager()

    var body: some View {
        VStack(spacing: 20) {
            if purchaseManager.hasUnlockedPro {
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
