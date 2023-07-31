//
//  Environment.swift
//  Garage
//
//  Created by Illia Romanenko on 25.07.23.
//

import Foundation

struct Environment {
    static var isPrem: Bool {
        get { SettingsManager.sh.read(.isPremium) ?? false }
        set { SettingsManager.sh.write(value: newValue, for: .isPremium)}
    }
    
    static var avaliblePlans: [PaidSubscription] = .empty
}
