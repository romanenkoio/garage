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
                labelVM: .init(text: "Ваш гараж пуст"),
                sublabelVM: .init(text: "Добавьте машину для \nначала работы"), addButtonVM: .init(title: "Добавить документ"),
                image: UIImage(systemName: "car")
            )
        }
        
        func readDocuments() {
            let data = RealmManager<Document>().read()
            tableVM.setCells(data)
        }
    }
}
