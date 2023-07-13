//
//  TopView+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 27.06.23.
//

import UIKit

extension CarTopInfoView {
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
            let formatter = TextFormatter()
            
            let carInfo = formatter.attrinutedLines(
                main: "\(car.brand) \(car.model)",
                font: .custom(size: 18, weight: .black),
                secondary: car.year.wrappedString,
                postfix: "год",
                lineSpacing: 5
            )
            
            let mileage = formatter.attrinutedLines(
                main: "Пробег",
                font: .custom(size: 12, weight: .bold),
                color: AppColors.subtitle,
                secondary: car.mileage.toString(),
                secondaryColor: AppColors.black,
                lineSpacing: 5,
                aligment: .center
            )
            
            if let vin = car.win {
                let vinString = formatter.attrinutedLines(
                    main: "VIN",
                    font: .custom(size: 12, weight: .bold),
                    color: AppColors.subtitle,
                    secondary: vin,
                    secondaryColor: AppColors.black,
                    lineSpacing: 5,
                    aligment: .center
                )
                
                vinLabelVM.textValue = .attributed(vinString)
            }
           
            brandModelYearLabelVM.textValue = .attributed(carInfo)
            milageLabelVM.textValue = .attributed(mileage)
            copyVINButtonVM.style = .basicLightTitle
            
            if let data = car.imageData {
                self.logo = UIImage(data: data)
            }
        }
    }
}
