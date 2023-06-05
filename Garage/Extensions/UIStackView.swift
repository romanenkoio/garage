//
//  UIStackView.swift
//  Logogo
//
//  Created by Illia Romanenko on 19.05.23.
//

import UIKit

extension UIStackView {
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
