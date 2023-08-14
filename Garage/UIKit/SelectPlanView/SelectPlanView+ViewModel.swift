//
//  SelectPlanView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 28.07.23.
//

import Foundation
import Combine

extension SelectPlanView {
    final class ViewModel: BasicViewModel {
        @Published var isSelected = false
        var selectedSubject: PassthroughSubject<SelectPlanView.ViewModel, Never> = .init()
        
        let periodLabelVM = BasicLabel.ViewModel()
        let priceLabelVM = BasicLabel.ViewModel()
        let cancelLabelVM = BasicLabel.ViewModel()
        var action: Completion?
        let subscription: PaidSubscription

        init(
            info: PaidSubscription,
            isSelected: Bool = false
        ) {
            self.isSelected = info.type == .year
            self.subscription = info
            var text = "\(info.price) \(info.currency)"
            switch info.type {
            case .month, .year:
                text += "/\(info.type.priceTitle)"
            default:
                break
            }
            priceLabelVM.textValue = .text(text)
            self.periodLabelVM.textValue = .text(info.type.duration)
            self.cancelLabelVM.textValue = .text(info.type.cancelTitle)
        }
    }
}
