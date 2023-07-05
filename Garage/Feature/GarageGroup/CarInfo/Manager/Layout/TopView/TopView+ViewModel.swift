//
//  TopView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 27.06.23.
//

import UIKit

extension TopView {
    class ViewModel: BasicViewModel {
        private(set) var car: Car
        
        let brandModelYearLabelVM = BasicLabel.ViewModel()
        let yearLabelVM = BasicLabel.ViewModel()
        let milageLabelVM = BasicLabel.ViewModel()
        let copyVINButtonVM = BasicButton.ViewModel()
        let vinLabelVM = BasicLabel.ViewModel()
        @Published var logo: UIImage?
        
        init(car: Car) {
            self.car = car
            super.init()
            initFields()
        }
        
        func initFields() {
            brandModelYearLabelVM.text = "\(car.brand) \(car.model)\nГод: \(car.year.wrapped)"
            vinLabelVM.text = "VIN\n\(car.win.wrapped)"
            milageLabelVM.text = "Пробег\n\(car.mileage)"
            copyVINButtonVM.style = .basicLightTitle
            
            if let data = car.imageData {
                self.logo = UIImage(data: data)
            }
        }
    }
}
