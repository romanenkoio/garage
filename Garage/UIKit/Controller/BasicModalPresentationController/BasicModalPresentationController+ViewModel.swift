//
//  BasicModalPresentationController+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 13.06.23.
//

import Foundation
import Combine

extension BasicModalPresentationController {
    class BasicControllerModel {
        @Published var title: String?
        
        var cancellables: Set<AnyCancellable> = []
        let validator = FormValidator()
    }
}

