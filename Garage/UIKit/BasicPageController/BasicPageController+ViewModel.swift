//
//  BasicPageController+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 19.06.23.
//

import UIKit

extension BasicPageController {
    final class ViewModel: BasicViewModel {
        @Published var controllers: [UIViewController]
        
        init(controllers: [UIViewController]) {
            self.controllers = controllers
        }
    }
}
