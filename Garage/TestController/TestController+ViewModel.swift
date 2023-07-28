//
//  TestController+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 8.06.23.
//

import Foundation

extension TestController {
    class ViewModel: BasicViewModel {

        let barChart = BarChart.GenericViewModel<Record>()

        override init() {
            barChart.setItems(
                list: RealmManager<Record>().read(),
                title: .text("Расходы за год")) { items in
                    return items.map({($0.id, $0.date.components.month ?? 0, $0.cost ?? 0)})
                }
        }
    }
}

