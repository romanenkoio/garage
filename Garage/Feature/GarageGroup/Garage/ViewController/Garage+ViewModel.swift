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
        var addButtonVM: AlignedButton.ViewModel

        override init() {
            addButtonVM = .init(buttonVM: .init(title: "Добавить машину"))
            
            super.init()
            readCars()
            
            tableVM.setupEmptyState(
                labelVM: .init(text: "Ваш гараж пуст"),
                sublabelVM: .init(text: "Добавьте машину для \nначала работы"),
                addButtonVM: addButtonVM.buttonVM,
                image: UIImage(named: "car")
            )
        }
        
        func readCars() {
            tableVM.setCells(RealmManager<Car>().read())
        }
    }
}
