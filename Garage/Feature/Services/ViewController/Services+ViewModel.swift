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
        typealias Suggestion = SuggestionView.ViewModel
        
        let tableVM = BasicTableView.GenericViewModel<ServiceView.ViewModel>()
        
        @Published
        var suggestions = [Suggestion]()
        
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
            makeSuggestions(services)
            tableVM.setCells(cells)
        }
        
        func makeSuggestions(_ items: [Service]) {
            guard !items.isEmpty else { return }
            
            let categories = items.map({ $0.specialisation.lowercased() }).unique
            
            guard categories.count != 1 else { return }
            let suggestions = categories.map({
                Suggestion(
                    labelVM: .init(
                        text: $0,
                        action: { [weak self] in
                            
                        })
                )})
            self.suggestions = suggestions
        }
    }
}
