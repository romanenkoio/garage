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
        let addButtonVM = FloatingButtonView.ViewModel()
        
        override init() {
            super.init()
            readDocuments()
            
            tableVM.setupEmptyState(
                labelVM: .init(.text("Документов нет")),
                sublabelVM: .init(.text("Добавьте документ для \nначала работы")), addButtonVM: .init(title: "Новый документ"),
                image: UIImage(named: "document")
            )
        }
        
        func readDocuments() {
            let data = RealmManager<Document>().read()
            var filteredData: [Document] = .empty
            let overdue: [Document] = data.filter({ $0.isOverdue && $0.endDate != nil }).sorted(by: { $0.endDate! < $1.endDate! })
            filteredData += overdue
            filteredData += data.filter({ !$0.isOverdue })
            tableVM.setCells(filteredData)
        }
    }
}
