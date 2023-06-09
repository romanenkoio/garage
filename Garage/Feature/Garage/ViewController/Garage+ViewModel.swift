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
        private(set) var cells: [Car] = []
        
        override init() {
            super.init()
            title = "Мой гараж"
            readCars()
        }
        
        func readCars() {
            cells = RealmManager<Car>().read()
        }
    }
}
