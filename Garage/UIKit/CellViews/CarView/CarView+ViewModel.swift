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
        let carPhotoCollectionVM: CarPhotoCollection.ViewModel
        @Published var image: UIImage?
        @Published var shouldShowAttention = false
        
        init(car: Car) {
            carPhotoCollectionVM = .init(images: car.images)
            super.init()
            brandLabelVM.text = "\(car.brand) \(car.model)"
            atteentionLabelVM.text = "Просрочена медицинская справка"
            plannedLabelVM.text = "Нет запланированных событий"
           

            
            shouldShowAttention = car.reminders.contains(where: { $0.days ?? .zero < 7 && $0.days ?? .zero > 0 })
            if car.reminders.isEmpty {
                plannedLabelVM.text = "Нет запланированных событий"
            } else {
                guard let first = car.reminders.first else {
                    plannedLabelVM.text = "Нет запланированных событий"
                    return
                }
                plannedLabelVM.text = "Ближайшее: \(first.short)"
            }
            
        }
    }
}
