//
//  UIStackView.swift
//  Logogo
//
//  Created by Illia Romanenko on 19.05.23.
//

import UIKit

extension UIStackView {
    typealias ViewSpacing = (UIView, spacing: CGFloat)
    
    func addArrangedSubview(_ config: [ViewSpacing]) {
        config.forEach({
            self.addArrangedSubview($0.0)
            self.setCustomSpacing($0.spacing, after: $0.0)
        })
    }
    
    func addArrangedSubviews(_ configs: [UIView]) {
        configs.forEach({ self.addArrangedSubview($0) })
    }

    func clearArrangedSubviews() {
        arrangedSubviews.forEach(completeRemoveArrangedSubview)
    }
    
    func completeRemoveArrangedSubview(_ view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
}
