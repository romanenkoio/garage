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
        @Published var title: String = .empty
        @Published var isLoadind: PassthroughSubject<Bool, Never> = .init()
        
        var cancellables: Set<AnyCancellable> = []
        let validator = FormValidator()
        
        init() {
            print("inited super model")
        }
    }
}
