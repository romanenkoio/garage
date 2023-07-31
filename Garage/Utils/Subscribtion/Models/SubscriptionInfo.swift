//
//  SubscriptionInfo.swift
//  Garage
//
//  Created by Yauheni Zhurauski on 30.07.23.
//

import Foundation

struct PaidSubscriptionInfo {
    public let status: PaidSubscriptionStatus
    let expirationDate: Date?
    let productID: String?
    
    init(status: PaidSubscriptionStatus, expirationDate: Date?, productID: String?) {
        self.status = status
        self.expirationDate = expirationDate
        self.productID = productID
    }
}
