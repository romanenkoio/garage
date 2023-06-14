//
//  UICollectionView.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 12.06.23.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: type.className)
    }

    func registerNib<T: UICollectionViewCell>(_ type: T.Type) {
        let nib = UINib(nibName: type.className, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: type.className)
    }

//    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type) -> T? {
//        self.dequeueReusableCell(type.className) as? T
//        self.dequeueReusableCell(type)
//    }

    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        self.dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as? T
    }
}
