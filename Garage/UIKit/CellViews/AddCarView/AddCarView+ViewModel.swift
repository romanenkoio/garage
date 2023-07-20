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

            let isPrem: Bool = SettingsManager.sh.read(.isPremium) ?? false
            let cars: [Car] = RealmManager().read()
            if isPrem {
                textLabelVM.textValue = .text("Добавить новую машину")
            } else if !isPrem, cars.count >= 1 {
                textLabelVM.textValue = .text("Достигнут лимит автомобилей")
            }
        }
    }
}
