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
    
    public init(
        id: String,
        currency: String,
        price: NSDecimalNumber
    ) {
        self.id = id
        self.currency = currency
        self.price = price
    }
}
