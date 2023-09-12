//
//  AttributedString+Extension.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 17.05.23.
//

import Foundation
import UIKit

extension String {
    func attributedString(
        font: UIFont,
        textColor: UIColor
    ) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: font
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
//    var localized: String {
//        return NSLocalizedString(self, comment: "")
//    }
//
//    func localized(_ args: CVarArg...) -> String {
//        return String(format: NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: ""), arguments: args)
//      }
}
