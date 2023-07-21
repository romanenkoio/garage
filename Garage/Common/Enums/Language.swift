//
//  Language.swift
//  Garage
//
//  Created by Illia Romanenko on 22.07.23.
//

import UIKit

enum Language: String, CaseIterable {
    case en
    case ru
    case by = "be"
    
    var image: UIImage? {
        return UIImage(named: "\(self.rawValue)_ic")?
            .resizeImage(targetSize: .init(width: 20, height: 20))?
            .withRenderingMode(.alwaysOriginal)
    }
}
