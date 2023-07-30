//
//  SubscriptionChecker.swift
//  Garage
//
//  Created by Yauheni Zhurauski on 30.07.23.
//

import Foundation

protocol SubscriptionChecker {
    func subscriptionStatus(completion: @escaping (Result<PaidSubscriptionInfo?, Error>)->Void)
}
