//
//  SubscriptionHandler.swift
//  Garage
//
//  Created by Yauheni Zhurauski on 30.07.23.
//

import Foundation

protocol SubscriptionsHandler {
    func getOfferings(completion: @escaping (Result<[PaidSubscription], Error>)->Void)
    func purchase(subscription: PaidSubscription, completion: @escaping (Error?)->Void)
    func restore(completion: @escaping (Error?)->Void)
    func currentSubscription(subscriptionID: String, completion: @escaping (Result<PaidSubscription, Swift.Error>) -> Void)
}
