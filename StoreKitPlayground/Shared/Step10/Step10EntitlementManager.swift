//
//  Step10EntitlementManager.swift
//  StoreKitPlayground (iOS)
//
//  Created by Josh Holtz on 9/18/22.
//

import SwiftUI

class Step10EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.your.app")!

    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}
