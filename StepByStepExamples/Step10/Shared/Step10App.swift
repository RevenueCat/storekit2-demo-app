//
//  Step10App.swift
//  Shared
//
//  Created by Josh Holtz on 9/19/22.
//

import SwiftUI

@main
struct Step10App: App {
    @StateObject
    private var entitlementManager: EntitlementManager

    @StateObject
    private var purchaseManager: PurchaseManager

    init() {
        let entitlementManager = EntitlementManager()
        let purchaseManager = PurchaseManager(entitlementManager: entitlementManager)
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._purchaseManager = StateObject(wrappedValue: purchaseManager)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(entitlementManager)
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}
