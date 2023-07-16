//
//  Bundle.swift
//  Garage
//
//  Created by Illia Romanenko on 16.07.23.
//

import Foundation

extension Bundle {
    private var releaseVersionNumber: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? .empty
    }
    
    private var buildVersionNumber: String {
        return (infoDictionary?["CFBundleVersion"] as? String) ?? .empty
    }
    
    var version: String {
        return "\(releaseVersionNumber)_\(buildVersionNumber)"
    }
}
