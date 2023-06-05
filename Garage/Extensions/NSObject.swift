//
//  NSObject.swift
//  Logogo
//
//  Created by Illia Romanenko on 22.05.23.
//

import Foundation

extension NSObject {
    static var className: String {
        String(describing: self)
    }
}
