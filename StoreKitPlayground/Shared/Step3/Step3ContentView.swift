//
//  Step3ContentView.swift
//  StoreKitPlayground (iOS)
//
//  Created by Josh Holtz on 9/11/22.
//

import SwiftUI
import StoreKit

struct Step3ContentView: View {
    @StateObject var purchaseManager = Step3PurchaseManager()

    var body: some View {
        VStack(spacing: 20) {
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
        }
    }
}
