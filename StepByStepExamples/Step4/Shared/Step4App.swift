//
//  Step4App.swift
//  Shared
//
//  Created by Josh Holtz on 9/19/22.
//

import SwiftUI

@main
struct Step4App: App {
    @StateObject
    private var purchaseManager = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}
