//
//  StoreKitPlaygroundApp.swift
//  Shared
//
//  Created by Josh Holtz on 9/1/22.
//

import SwiftUI

@main
struct StoreKitPlaygroundApp: App {

    let transactionObserver = TransactionObserver()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
