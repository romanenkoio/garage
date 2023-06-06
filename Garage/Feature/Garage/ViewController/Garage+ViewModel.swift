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
        
        @Published
        private(set) var cells: [CarView.ViewModel] = []
        
        override init() {
            super.init()
            cells = RealmManager<Car>().read().map({
                    .init(
                        brand: $0.brand,
                        model: $0.model,
                        image: UIImage(systemName: "car")
                    )
                })
        }
    }
}
