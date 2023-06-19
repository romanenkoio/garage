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
        let addButtonVM = AlignedButton.ViewModel(
            buttonVM: .init(title: "Добавить документ")
        )
        
        override init() {
            super.init()
            readDocuments()
            
            tableVM.setupEmptyState(
                labelVM: .init(text: "Документов нет"),
                sublabelVM: .init(text: "Добавьте документ для \nначала работы"), addButtonVM: .init(title: "Новый документ"),
                image: UIImage(named: "document")
            )
        }
        
        func readDocuments() {
            let data = RealmManager<Document>().read()
            tableVM.setCells(data)
        }
    }
}
