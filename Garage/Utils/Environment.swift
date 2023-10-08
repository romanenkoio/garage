//
//  Environment.swift
//  Garage
//
//  Created by Illia Romanenko on 25.07.23.
//

import Foundation

struct Environment {
    static var isPrem: Bool {
        get {
            if SettingsManager.sh.read(.isPromoPrem) ?? false {
                return true
            } else {
                return SettingsManager.sh.read(.isPremium) ?? false
            }
        }
           
        set {
            SettingsManager.sh.write(value: newValue, for: .isPremium)
        }
    }
    
    static var avaliblePlans: [PaidSubscription] = .empty
}
