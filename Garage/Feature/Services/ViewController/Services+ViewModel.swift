//
//  Services+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

extension ServicesViewController {
    final class ViewModel: BasicViewModel {
        let tableVM = BasicTableView.ViewModel()
        
        override init() {
            super.init()
            
            tableVM.setupEmptyState(
                labelVM: .init(text: "Нет данных"),
                image: UIImage(systemName: "car")
            )
        }
    }
}
