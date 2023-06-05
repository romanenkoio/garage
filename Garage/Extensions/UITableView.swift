//
//  UITableView.swift
//  Logogo
//
//  Created by Illia Romanenko on 22.05.23.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) {
        self.register(T.self, forCellReuseIdentifier: type.className)
    }

    func registerNib<T: UITableViewCell>(_ type: T.Type) {
        let nib = UINib(nibName: type.className, bundle: nil)
        self.register(nib, forCellReuseIdentifier: type.className)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T? {
        self.dequeueReusableCell(withIdentifier: type.className) as? T
    }

    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as? T
    }
}
