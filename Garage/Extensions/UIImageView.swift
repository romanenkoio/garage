//
//  UIImageView.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(from url: String) {
        guard let url = URL(string: url) else { return }
        self.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "car")
        )
    }
}
