//
//  Step1ContentView.swift
//  StoreKitPlayground (iOS)
//
//  Created by Josh Holtz on 9/9/22.
//

import SwiftUI
import StoreKit

struct Step1ContentView: View {
    let productIds = ["pro_monthly", "pro_yearly", "pro_lifetime"]

    @State var products: [Product] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Products")
            ForEach(self.products) { (product) in
                Button {
                    // Don't do anything yet
                } label: {
                    Text("\(product.displayPrice) - \(product.displayName)")
                        .foregroundColor(.white)
                        .padding()
                        .background(.blue)
                        .clipShape(Capsule())
                }
            }
        }.task {
            do {
                try await self.loadProducts()
            } catch {
                print(error)
            }
        }
    }

    private func loadProducts() async throws {
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
}
