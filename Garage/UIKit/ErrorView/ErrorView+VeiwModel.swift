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
        @Published var errorLabelVM = BasicLabel.ViewModel()
        @Published var image: UIImage? = UIImage(named: "error_ic")
        
        init(error: String = .empty) {
            super.init()
            errorLabelVM.text = error
        }
    }
}
