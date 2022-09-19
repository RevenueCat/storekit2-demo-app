//
//  Step7EntitlementManager.swift
//  StoreKitPlayground (iOS)
//
//  Created by Josh Holtz on 9/17/22.
//

import SwiftUI

class Step7EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.your.app")!

    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}
