//
//  Garage+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

extension GarageViewController {
    final class ViewModel: BasicControllerModel {
        let addCarButton = BasicButton.ViewModel(
            title: "Добавить машину",
            style: .primary
        )
        
        @Published
        private(set) var cells: [CarView.ViewModel] = []
        
        override init() {
            super.init()
            title = "Мой гараж"
            readCars()
        }
        
        func readCars() {
            cells = RealmManager<Car>().read().map({
                .init(
                    brand: $0.brand,
                    model: $0.model,
                    logoURL: "https://46.175.171.150/cars-logos/api/images/\($0.brand.lowercased())_resized.png"
                )
            })
        }
        
        
        func selectCar(at index: IndexPath) {
            
        }
    }
}
