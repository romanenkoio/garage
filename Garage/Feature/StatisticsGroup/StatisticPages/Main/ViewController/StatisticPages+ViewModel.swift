//
//  Main+ViewModel.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 28.08.23.
//  
//

import UIKit

extension StatisticPagesViewController {
    final class ViewModel: BasicViewModel {
        private(set) var car: Car
        
        let pageVM: BasicPageController.ViewModel
        let chartsVM: ChartsViewController.ViewModel
        let statisticVm: StatisticViewController.ViewModel
        let segmentVM: BasicSegmentView<StatisticType>.GenericViewModel<StatisticType>
        
        
        init(car: Car) {
            self.car = car
            
            segmentVM = .init(
                StatisticType.allCases,
                selected: .charts,
                titles: { items in items.map({$0.title}) }
            )
            
            chartsVM = .init(car: car)
            statisticVm = .init(car: car)
            
            pageVM = .init(
                controllers:
                    [
                        ChartsViewController(vm: chartsVM),
                        StatisticViewController(vm: statisticVm)
                    ])
            
            super.init()
            
            pageVM.$index
                .removeDuplicates()
                .sink { [weak self] value in
                    guard let selected = StatisticType.allCases[safe: value] else { return }
                    self?.segmentVM.setSelected(selected)
                }
                .store(in: &cancellables)
            
            segmentVM.$selectedIndex.sink { [weak self] value in
                self?.pageVM.index = value
            }
            .store(in: &cancellables)
         
        }
    }
}
