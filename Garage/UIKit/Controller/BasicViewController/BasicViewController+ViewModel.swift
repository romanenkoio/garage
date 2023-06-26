//
//  BasicViewController+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import UIKit
import Combine

extension BasicViewController {
    class BasicControllerModel {
        @Published var isLoadind: PassthroughSubject<Bool, Never> = .init()
        var cancellables: Set<AnyCancellable> = []
        let validator = FormValidator()
        let changeChecker = FormChangeChecker()
    }
}
