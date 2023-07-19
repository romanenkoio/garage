//
//  SPIndicator.swift
//  Garage
//
//  Created by Illia Romanenko on 20.07.23.
//

import Foundation
import SPIndicator

extension SPIndicator {
    static func show(title: String, message: String? = nil) {
        DispatchQueue.main.async {
            SPIndicator.present(
                title: title,
                message: message,
                preset: .done,
                haptic: .success,
                from: .top
            )
        }
    }
}
