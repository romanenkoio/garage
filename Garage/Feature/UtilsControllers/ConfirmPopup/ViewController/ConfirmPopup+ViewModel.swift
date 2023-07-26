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
        
        let confirmLabelVM = BasicLabel.ViewModel()
        let subtitleLabelVM = BasicLabel.ViewModel()
        let confirmButton = BasicButton.ViewModel(title: "Удалить".localized, style: .popup(color: UIColor(hexString: "#E84949")))
        let cancelButton = BasicButton.ViewModel(title: "Отмена".localized, style: .popup())
        var action: Completion?
        
        init(
            title: TextValue,
            subtitle: TextValue = .text(.empty),
            confirmTitle: String? = nil,
            confirmColor: UIColor? = nil,
            confirmAction: Completion? = nil
        ) {
            self.confirmLabelVM.textValue = title
            self.subtitleLabelVM.textValue = subtitle
            self.action = confirmAction
            
            if let confirmTitle {
                self.confirmButton.title = confirmTitle
            }
            
            if let confirmColor {
                self.confirmButton.style = .popup(color: confirmColor)
            }
        }
    }
}
