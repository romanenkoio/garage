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
        @Published var controllers: [BasicViewController]
        @Published var index = 0
        var indexCandidate: Int?
        
        init(controllers: [BasicViewController]) {
            self.controllers = controllers
        }
        
        func setIndexCandidate() {
            guard let indexCandidate else { return }
            self.index = indexCandidate
        }
    }
}
