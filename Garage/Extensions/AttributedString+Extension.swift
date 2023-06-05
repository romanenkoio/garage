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
}
