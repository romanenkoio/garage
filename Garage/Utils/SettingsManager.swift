//
//  SettingsManager.swift
//  Garage
//
//  Created by Illia Romanenko on 14.06.23.
//

import Foundation

final class SettingsManager {
    static let sh = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    enum Keys: String, CaseIterable {
        case colorSet
        case useReminder
    }
    
    func read(_ key: Keys) -> Bool? {
        let value = defaults.object(forKey: key.rawValue) as? Bool
        return value
    }
    
    func read(_ key: Keys) -> String {
        let value = defaults.object(forKey: key.rawValue) as? String ?? .empty
        return value
    }
    
    func read(_ key: Keys) -> Int? {
        let value = defaults.object(forKey: key.rawValue) as? Int
        return value
    }
    
    func write(value: String, for key: Keys) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func write(value: Int, for key: Keys) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func write(value: Bool, for key: Keys) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func removeAll() {
        let allCases = Keys.allCases
        allCases.forEach { key in
            defaults.set(nil, forKey: key.rawValue)
        }
    }
}
