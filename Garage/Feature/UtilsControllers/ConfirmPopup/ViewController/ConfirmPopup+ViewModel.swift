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
        let imageViewVM = BasicImageView.ViewModel(
            image: UIImage(named: "delete_popup_ic"),
            mode: .scaleAspectFit
        )
        var action: Completion?
        
        init(
            title: TextValue,
            subtitle: TextValue = .text(.empty),
            confirmTitle: String? = nil,
            confirmColor: UIColor? = nil,
            confirmAction: Completion? = nil,
            style: Style = .standart
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
            super.init()
            setStyle(style)
        }
        
        private func setStyle(_ style: Style) {
            switch style {
                
            case .standart:
                break
                // MARK: standart dialog case
            case .error:
                confirmButton.isHidden = true
                imageViewVM.image = UIImage(named: "error_ic")
                break
            case .success:
                confirmButton.isHidden = true
                imageViewVM.image = UIImage(named: "selection_ic")
                break
            }
        }
    }
}

extension ConfirmPopupViewController.ViewModel {
    enum Style {
        case standart
        case error
        case success
    }
}
