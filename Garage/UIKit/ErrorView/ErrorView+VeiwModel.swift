//
//  ErrorView+VeiwModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 18.05.23.
//

import Combine
import UIKit

extension ErrorView {
    final class ViewModel: BasicViewModel {
        @Published var error: String
        @Published var image: UIImage?
        
        init(
            error: String = .empty,
            image: UIImage? = UIImage(systemName: "info.circle")
        ) {
            self.error = error
            self.image = image
        }
    }
}
