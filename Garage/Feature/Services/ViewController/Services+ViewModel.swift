//
//  Services+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit

extension ServicesViewController {
    final class ViewModel: BasicControllerModel {
        typealias Suggestion = SuggestionView.ViewModel
        
        let tableVM = BasicTableView.GenericViewModel<ServiceView.ViewModel>()
        
        @Published
        var suggestions = [Suggestion]()
        
        override init() {
            super.init()
            tableVM.setupEmptyState(
                labelVM: .init(text: "Ваш гараж пуст"),
                sublabelVM: .init(text: "Добавьте машину для \nначала работы"),
                addButtonVM: .init(title: "Добавить сервис"),
                image: UIImage(named: "car")
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
                            
                        }),
                    image: nil
                )})
            self.suggestions = suggestions
        }
    }
}
