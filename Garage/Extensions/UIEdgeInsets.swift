//
//  UIEdgeInsets.swift
//  Logogo
//
//  Created by Illia Romanenko on 19.05.23.
//

import UIKit

extension UIEdgeInsets {
    static var horizintal = UIEdgeInsets(horizontal: 21)

    init(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }

    init(top: CGFloat = 0, bottom: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: top, left: horizontal, bottom: bottom, right: horizontal)
    }

    init(vertical: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: vertical, left: left, bottom: vertical, right: right)
    }

    init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }

    var vertical: CGFloat {
        top + bottom
    }

    var horizontal: CGFloat {
        left + right
    }

    var directionalEdgeInsets: NSDirectionalEdgeInsets {
        .init(top: top, leading: left, bottom: bottom, trailing: right)
    }

    func withTop(_ value: CGFloat) -> Self {
        .init(top: value, left: left, bottom: bottom, right: right)
    }

    func withBottom(_ value: CGFloat) -> Self {
        .init(top: top, left: left, bottom: value, right: right)
    }

    func withLeft(_ value: CGFloat) -> Self {
        .init(top: top, left: value, bottom: bottom, right: right)
    }

    func withRight(_ value: CGFloat) -> Self {
        .init(top: top, left: left, bottom: bottom, right: value)
    }

    static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        .init(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }

    static func - (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        .init(
            top: lhs.top - rhs.top,
            left: lhs.left - rhs.left,
            bottom: lhs.bottom - rhs.bottom,
            right: lhs.right - rhs.right
        )
    }
}
