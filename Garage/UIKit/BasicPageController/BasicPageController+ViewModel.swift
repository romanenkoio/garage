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
        var index: PassthroughSubject<Int, Never> = .init()

        init(controllers: [UIViewController]) {
            self.controllers = controllers
        }
    }
}
