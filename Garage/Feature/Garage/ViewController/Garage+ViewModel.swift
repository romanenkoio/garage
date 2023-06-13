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

        let tableVM = BasicTableView.GenericViewModel<Car>()

        override init() {
            super.init()
            readCars()
            tableVM.setupEmptyState(
                labelVM: .init(text: "Нет данных"),
                image: UIImage(systemName: "car")
            )
        }
        
        func readCars() {
            tableVM.setCells(RealmManager<Car>().read())
        }
    }
}
