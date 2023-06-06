//
//  Garage+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

extension GarageViewController {
    final class ViewModel: BasicViewModel {
        let addCarButton = BasicButton.ViewModel(
            title: "Добавить машину",
            style: .primary
        )
        
        override init() {
            super.init()
        }
    }
}
