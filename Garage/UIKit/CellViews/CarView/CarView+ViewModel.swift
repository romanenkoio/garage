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
        let imageVM = BasicImageView.ViewModel(mode: .scaleAspectFill)
        @Published var shouldShowAttention = false
        let car: Car
        
        init(car: Car) {
            self.car = car
            super.init()
            imageVM.set(from: car.images.first, placeholder: UIImage(named: "car_placeholder"))
            brandLabelVM.textValue = .text("\(car.brand) \(car.model)")
            atteentionLabelVM.textValue = .text("Просрочена медицинская справка")
            plannedLabelVM.textValue = .text("Нет запланированных событий")
                       
            shouldShowAttention = car.reminders.contains(where: { $0.days ?? .zero < 7 && $0.days ?? .zero > 0 })
            if car.reminders.isEmpty {
                plannedLabelVM.textValue = .text("Нет запланированных событий")
            } else {
                guard let first = car.reminders.first else {
                    plannedLabelVM.textValue = .text("Нет запланированных событий")
                    return
                }
                plannedLabelVM.textValue = .text("Ближайшее: \(first.short)")
            }
            
        }
    }
}
