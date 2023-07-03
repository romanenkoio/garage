//
//  ConfirmPopup+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 23.06.23.
//  
//

import UIKit

extension ConfirmPopupViewController {
    final class ViewModel: BasicViewModel {
        
        let confirmLabelVM: BasicLabel.ViewModel
        let confirmButton = BasicButton.ViewModel(title: "Удалить", style: .popup(color: UIColor(hexString: "#E84949")))
        let cancelButton = BasicButton.ViewModel(title: "Отмена", style: .popup())
        
        init(titleVM: BasicLabel.ViewModel) {
            self.confirmLabelVM = titleVM
            super.init()
        }
    }
}
