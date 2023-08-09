//
//  Subscription.swift
//  Garage
//
//  Created by Yauheni Zhurauski on 30.07.23.
//

import Foundation

struct PaidSubscription: Equatable {
    let id: String
    public let currency: String
    public let price: NSDecimalNumber
    let type: SubscriptionType
    
    public init(
        id: String,
        currency: String,
        price: NSDecimalNumber,
        type: SubscriptionType
    ) {
        self.id = id
        self.currency = currency
        self.price = price
        self.type = type
    }
    
    static func == (lhs: PaidSubscription, rhs: PaidSubscription) -> Bool {
        return lhs.id == rhs.id
    }
}
