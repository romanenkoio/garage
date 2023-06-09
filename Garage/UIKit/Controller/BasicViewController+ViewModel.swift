//
//  BasicViewController+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import Foundation
import Combine

extension BasicViewController {
    class BasicControllerModel {
        @Published var title: String?
        
        var cancellables: Set<AnyCancellable> = []
        let validator = FormValidator()
    }
}
