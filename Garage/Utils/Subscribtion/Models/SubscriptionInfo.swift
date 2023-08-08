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
    let type: SubscriptionType?
    
    init(
        status: PaidSubscriptionStatus,
        expirationDate: Date?,
        productID: String?,
        type: SubscriptionType?
    ) {
        self.status = status
        self.expirationDate = expirationDate
        self.productID = productID
        self.type = type
    }
}

extension PaidSubscriptionInfo {
    static let inactive = PaidSubscriptionInfo(
        status: .inactive,
        expirationDate: nil,
        productID: nil,
        type: .none
    )
}
