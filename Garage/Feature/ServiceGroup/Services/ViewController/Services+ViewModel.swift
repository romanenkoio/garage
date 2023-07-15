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
        let addButtonVM = FloatingButtonView.ViewModel()
        
        @Published
        var suggestions = [Suggestion]()
        private let generator = UIImpactFeedbackGenerator(style: .medium)
        var isAnimation = false
        
        override init() {
            super.init()
            tableVM.setupEmptyState(
                labelVM: .init(.text("Ваш гараж пуст")),
                sublabelVM: .init(.text("Сервисов нет")),
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
            
            guard categories.count > 2 else { return }
            let all = Suggestion(labelVM: .init(.text("Все"), action: nil))
            all.labelVM.action = { [weak self] in
                guard let self else { return }
                let services = RealmManager<Service>().read()
                self.tableVM.setCells(services)
                self.changeSelection(selected: all)
                generator.impactOccurred()
            }
            all.isSelected = true
            
            let suggestions = categories.map({
                let spec = $0.lowercased()

                let suggestion = Suggestion(labelVM: .init(
                    .text($0.capitalizingFirstLetter()),
                    action: nil
                ))
                suggestion.labelVM.action = { [weak self] in
                    guard let self else { return }
                    let services = RealmManager<Service>()
                        .read()
                        .filter({ $0.specialisation.lowercased() == spec })
                    self.changeSelection(selected: suggestion)
                    self.tableVM.setCells(services)
                    generator.impactOccurred()
                }
                return suggestion
            })

            self.suggestions.removeAll()
            self.suggestions.append(all)
            self.suggestions += suggestions
        }
        
        private func changeSelection(selected: Suggestion) {
            suggestions.forEach({ $0.isSelected = false })
            selected.isSelected = true
        }
    }
}
