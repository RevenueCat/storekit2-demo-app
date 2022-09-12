//
//  Step3VerifyReceipt.swift
//  StoreKitPlayground
//
//  Created by Josh Holtz on 9/1/22.
//

import Foundation
import StoreKit

// THOUGHTS
// 1. How to parse receipt logic look helpful but was not
//   - https://developer.apple.com/documentation/storekit/in-app_purchase/original_api_for_in-app_purchase/unlocking_purchased_content

struct Thing {
    static func thing() {
        
    }
}

struct Receipt {
    static func verify() async {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            // TODO: Not receipt url so do something
            return
        }

        do {
            let receiptData = try Data(contentsOf: receiptURL)
            let receiptString = String(data: receiptData, encoding: .utf8)

            print("receiptString: \(receiptString)")
            // Custom method to work with receipts



//            let rocketCarEnabled = receipt(receiptData, includesProductID: "com.example.rocketCar")
            } catch {
                print(error)
        }
    }
}
