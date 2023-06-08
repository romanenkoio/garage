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
        let tableVM = BasicTableView.GenericViewModel<ServiceView.ViewModel>()
        
        override init() {
            super.init()
            
            tableVM.setupEmptyState(
                labelVM: .init(text: "Нет данных"),
                image: UIImage(systemName: "car")
            )
        }
        
        func readServices() {
            let services = RealmManager<Service>().read()
            let cells = services.map({ ServiceView.ViewModel(service: $0) })
            tableVM.setCells(cells)
        }
    }
}
