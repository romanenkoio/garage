//
//  AddCarView+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 21.06.23.
//

import UIKit

extension AddCarView {
    final class ViewModel: BasicViewModel {
        let textLabelVM = BasicLabel.ViewModel()
        let imageVM = BasicImageView.ViewModel(image: UIImage(named: "plus_car_ic"))
        
        override init() {
            let cars: [Car] = RealmManager().read()
            if Environment.isPrem {
                textLabelVM.textValue = .text("Добавить новую машину".localized)
            } else if !Environment.isPrem, cars.count >= 1 {
                textLabelVM.textValue = .text("Достигнут лимит автомобилей".localized)
            }
        }
    }
}
