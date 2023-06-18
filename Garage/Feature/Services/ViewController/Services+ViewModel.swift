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
        
        let tableVM = BasicTableView.GenericViewModel<Service>()
        let addButtonVM = AlignedButton.ViewModel(
            buttonVM: .init(title: "Добавить документ")
        )
        
        @Published
        var suggestions = [Suggestion]()
        
        override init() {
            super.init()
            tableVM.setupEmptyState(
                labelVM: .init(text: "Ваш гараж пуст"),
                sublabelVM: .init(text: "Сервисов нет"),
                addButtonVM: .init(title: "Добавить сервис"),
                image: UIImage(named: "service")
            )
        }
        
        func readServices() {
            let services = RealmManager<Service>().read()
            makeSuggestions(services)
            tableVM.setCells(services)
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
