//
//  CarView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import UIKit

extension CarView {
    class ViewModel: BasicViewModel {
        let detailsVM = DetailsView.ViewModel()
        let brandLabelVM = BasicLabel.ViewModel()
        let plannedLabelVM = BasicLabel.ViewModel()
        let atteentionLabelVM = BasicLabel.ViewModel()
        let imageVM = BasicImageView.ViewModel(image: nil, mode: .scaleAspectFill)
        @Published var shouldShowAttention = false
        let car: Car
        
        init(car: Car) {
            self.car = car
            super.init()
            imageVM.set(from: car.images.first, placeholder: UIImage(named: "car_placeholder"))
            brandLabelVM.textValue = .text("\(car.brand) \(car.model)")
            plannedLabelVM.textValue = .text("Нет запланированных событий".localized)
                       
            shouldShowAttention = car.reminders.contains(where: { $0.days ?? .zero < 7 && $0.days ?? .zero > 0 })
            if car.reminders.isEmpty {
                plannedLabelVM.textValue = .text("Нет запланированных событий".localized)
            } else {
                guard let first = car.reminders.first else {
                    plannedLabelVM.textValue = .text("Нет запланированных событий".localized)
                    return
                }
                plannedLabelVM.textValue = .text("Ближайшее:".localized(first.short))
            }
            
        }
    }
}
