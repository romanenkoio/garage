//
//  CarInfo+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//  
//

import UIKit

extension CarInfoViewController {
    final class ViewModel: BasicViewModel {
        
        private(set) var car: Car

        let segmentVM: BasicSegmentView<RecordType>.GenericViewModel<RecordType>
        let topStackVM: CarTopInfoView.ViewModel
        let tableVM = BasicTableView.GenericViewModel<Record>()
        var pageVM: BasicPageController.ViewModel
        var pastRecordsVM: PastRecordsViewController.ViewModel
        var remindersVM: RemindersViewController.ViewModel
        let addButtonVM = FloatingButtonView.ViewModel()
        
        @Published var logo: UIImage?
        
        init(car: Car) {
            self.car = car
            
            segmentVM = .init(
                RecordType.allCases,
                selected: .paste,
                titles: { items in items.map({ $0.title}) }
            )
            
            pastRecordsVM = .init(car: car)
            remindersVM = .init(car: car)
            
            pageVM = .init(
                controllers: [
                    PastRecordsViewController(vm: pastRecordsVM),
                    RemindersViewController(vm: remindersVM)
                ])
            
            topStackVM = .init(car: self.car)
            super.init()
         
            initFields()
            
            pageVM.$index.removeDuplicates().sink { [weak self] value in
                guard let selected = RecordType.allCases[safe: value] else { return }
                self?.segmentVM.setSelected(selected)
            }
            .store(in: &cancellables)
            
            segmentVM.$selectedIndex.sink { [weak self] value in
                self?.pageVM.index = value
            }
            .store(in: &cancellables)
        }
        
        func readCar() {
            guard let car = RealmManager<Car>().read().first(where: { $0.id == car.id }) else { return }
            self.car = car
            self.initFields()
            self.pastRecordsVM.readRecords()
            self.remindersVM.readReminders()
        }
        
        func readRecords(for car: Car) {
            let records = RealmManager<Record>().read().filter({$0.carID == car.id})
            
            tableVM.setCells(records)
        }
        
        func initFields() {
            if let photo = car.images.first {
                topStackVM.logoVM.set(from: photo)
                topStackVM.logoVM.mode = .scaleAspectFill
            } else if let data = car.imageData {
                topStackVM.logoVM.image = UIImage(data: data)
                topStackVM.logoVM.mode = .scaleAspectFit
            } else {
                topStackVM.logoVM.image = UIImage(named: "logo_placeholder")
                topStackVM.logoVM.mode = .scaleAspectFit
            }
        }
    }
}
