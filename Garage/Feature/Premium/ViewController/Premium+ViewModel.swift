//
//  Premium+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 28.07.23.
//  
//

import UIKit

extension PremiumViewController {
    final class ViewModel: BasicViewModel {
        let topLabelVM = BasicLabel.ViewModel()
        let logoImageVM = BasicImageView.ViewModel(image: UIImage(named: "prem_logo"), mode: .scaleAspectFit)
        let closeImageVM: ActionImage.ViewModel
        let startTrialButton = BasicButton.ViewModel(title: "Начать бесплатно 3 дня", style: .popup(color: UIColor(hexString: "#33BC4A"), corner: 20))
        let restoreVM = TappableLabel.ViewModel(.text("Восстановить"))
        let termsVM = TappableLabel.ViewModel(.text("Условия"))
        let privacyVM = TappableLabel.ViewModel(.text("Приватность"))
        @Published var plans: [SelectPlanView.ViewModel] = .empty
        
        
        override init() {
            closeImageVM = .init(image: UIImage(named: "cancel_ic"))
            
            let string = "Перейди на премиум план"
            let range = (string as NSString).range(of: "премиум")
            let myAttribute: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.custom(size: 38, weight: .regular)
            ]

            let mutableAttributedString = NSMutableAttributedString(string: string, attributes: myAttribute)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hexString: "#65F473"), range: range)
            
            topLabelVM.textValue = .attributed(mutableAttributedString)
            
            plans = Environment.avaliblePlans.map({ SelectPlanView.ViewModel(info: $0) })
        }
    }
}
