//
//  ClientView+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 20.05.23.
//

import Foundation

extension ClienView {
    final class ViewModel {
        let nameVM = BasicLabel.ViewModel()
        let phoneVM = BasicLabel.ViewModel()
        
//        init(client: ClientModel) {
//            nameVM.text = "\(client.surname) \(client.name)"
//            phoneVM.text = "+375-25-777-66-55"
//        }
//        
//        init(parent: ParentModel) {
//            nameVM.text = "\(parent.surname) \(parent.name)"
//            phoneVM.text = parent.phone
//        }
    }
}
