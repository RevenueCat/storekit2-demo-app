//
//  EntitlementManager.swift
//  DemoApp
//
//  Created by Josh Holtz on 9/19/22.
//

import SwiftUI

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.your.app")!

    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}
