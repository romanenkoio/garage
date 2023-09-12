//
//  Bundle.swift
//  Garage
//
//  Created by Illia Romanenko on 16.07.23.
//

import Foundation
import UIKit

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
    
    static func setLocalization() {
//        object_setClass(Bundle.main, AnyLanguageBundle.self)
    }

//    private final class AnyLanguageBundle: Bundle {
//        override func localizedString(
//            forKey key: String,
//            value: String?,
//            table tableName: String?
//        ) -> String {
//            let selectedLanguage: String
//            if let language: String = SettingsManager.sh.read(.selectedLanguage) {
//                selectedLanguage = language
//            } else {
//                selectedLanguage = "be"
//            }
//            guard let path = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj"),
//                  let bundle = Bundle(path: path)
//            else {
//                return superString(forKey: key, value: value, table: tableName)
//            }
//            return bundleString(forKey: key, value: value, table: tableName)
//        }
//    }
}
