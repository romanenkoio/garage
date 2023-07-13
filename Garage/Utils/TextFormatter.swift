//
//  TextFormatter.swift
//  Garage
//
//  Created by Illia Romanenko on 14.07.23.
//

import UIKit

final class TextFormatter {
    func attrinutedLines(
        main: String,
        font: UIFont,
        color: UIColor = AppColors.black,
        secondary: String?,
        postfix: String? = nil,
        secondaryFont: UIFont = .custom(size: 14, weight: .bold),
        secondaryColor: UIColor = AppColors.subtitle,
        lineSpacing: Int,
        aligment: NSTextAlignment = .left
    ) -> NSAttributedString {
        let first: NSMutableAttributedString = .init(
            string: main,
            attributes: [.font: font, .foregroundColor: color]
        )
        
        guard var secondary, !secondary.isEmpty else { return first }
        
        if let postfix {
            secondary.append(" ")
            secondary.append(postfix)
        }
        
        let second: NSAttributedString = .init(
            string: "\n\(secondary)",
            attributes: [.font: secondaryFont, .foregroundColor: secondaryColor]
        )
        
        first.append(second)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = CGFloat(lineSpacing)
        style.alignment = aligment
        first.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: first.length))
        return first
    }
}
