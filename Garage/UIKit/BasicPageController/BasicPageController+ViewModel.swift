//
//  BasicPageController+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 19.06.23.
//

import UIKit
import Combine

extension BasicPageController {
    final class ViewModel: BasicViewModel {
        @Published var controllers: [UIViewController]
        @Published var index = 0
        var indexCandidate: Int?
        
        init(controllers: [UIViewController]) {
            self.controllers = controllers
        }
        
        func setIndexCandidate() {
            guard let indexCandidate else { return }
            self.index = indexCandidate
        }
    }
}
