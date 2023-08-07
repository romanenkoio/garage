//
//  String.swift
//  Logogo
//
//  Created by Illia Romanenko on 13.05.23.
//

import UIKit

extension Optional where Wrapped == String {
    var wrapped: String {
        return self ?? .empty
    }
}

extension String {
    static let empty = ""
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func toInt() -> Int {
        return Int(String(self.compactMap({ $0.isWhitespace ? nil : $0 }))) ?? .zero
    }
    
    func toDouble() -> Double {
        var mutatingString = self.replacingOccurrences(of: "[^-0-9.]", with: "", options: .regularExpression)
            .components(separatedBy: .whitespaces)
            .joined(separator: "")

        if self.contains(",") {
            mutatingString = mutatingString.replacingOccurrences(of: ",", with: ".")
        }

        return Double(mutatingString) ?? .zero
    }
    
    func clearDigit() -> String {
        let result = self.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
        return result
    }
    
    func insertImage(
        _ image: UIImage?,
        offset: CGPoint = CGPoint(x: -5, y: -3),
        size: CGSize = CGSize(width: 15, height: 15)
    ) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(
            origin: offset,
            size: size
        )
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: "  " + self )
        completeText.append(textAfterIcon)
        return completeText
    }
    
    func appendCurrency() -> String {
        let locale = Locale.current
        guard let currencySymbol = locale.currencySymbol else { return self }
        return self + " \(currencySymbol)"
    }
}
