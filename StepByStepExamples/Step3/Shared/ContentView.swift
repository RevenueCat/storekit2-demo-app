//
//  ContentView.swift
//  Shared
//
//  Created by Josh Holtz on 9/19/22.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @EnvironmentObject
    private var purchaseManager: PurchaseManager

    var body: some View {
        VStack(spacing: 20) {
            Text("Products")
            ForEach(purchaseManager.products) { product in
                Button {
                    _ = Task<Void, Never> {
                        do {
                            try await purchaseManager.purchase(product)
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
        }.task {
            _ = Task<Void, Never> {
                do {
                    try await purchaseManager.loadProducts()
                } catch {
                    print(error)
                }
            }
        }
    }
}
