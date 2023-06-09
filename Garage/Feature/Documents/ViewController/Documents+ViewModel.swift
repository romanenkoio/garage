//
//  Documents+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//  
//

import UIKit

extension DocumentsViewController {
    final class ViewModel: BasicViewModel {
        
        let tableVM = BasicTableView.GenericViewModel<Document>()
        
        override init() {
            super.init()
            readDocuments()
            
            tableVM.setupEmptyState(
                labelVM: .init(text: "Нет данных"),
                image: UIImage(systemName: "car")
            )
        }
        
        func readDocuments() {
            let data = RealmManager<Document>().read()
            tableVM.setCells(data)
        }
    }
}
