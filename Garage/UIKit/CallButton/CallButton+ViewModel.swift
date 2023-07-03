//
//  CallButton+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 24.06.23.
//

import UIKit

extension CallButton {
    final class ViewModel: BasicViewModel {
        let phone: String
        
        init(phone: String) {
            self.phone = phone
        }
        
        func call() {
            guard let number = URL(string: "tel://" + "\(phone.clearDigit())") else { return }
            UIApplication.shared.open(number)
        }
    }
}
