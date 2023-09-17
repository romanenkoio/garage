//
//  Reusable.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 17.09.23.
//

import UIKit

@objc protocol Reusable {
   @objc func prepareForViewReuse()
}

extension UIView: Reusable {
    /// Called when UIView reused in UITableView
    func prepareForViewReuse() {}
}
