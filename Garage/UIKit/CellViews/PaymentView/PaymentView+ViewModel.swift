//
//  PaymentView+ViewModel.swift
//  Logogo
//
//  Created by Illia Romanenko on 20.05.23.
//

import Foundation

extension PaymentView {
    final class ViewModel: BasicViewModel {
        let dateLabelVM = BasicLabel.ViewModel()
        let nameLabelVM = BasicLabel.ViewModel()
        
        @Published var isLast = false
        
//        init(
//            payment: PaymentModel,
//            client: ClientModel,
//            isLast: Bool
//        ) {
//            self.dateLabelVM.text = "27 мая, "
//            self.nameLabelVM.text = client.name + " " + client.surname
//            self.isLast = isLast
//        }
    }
}
