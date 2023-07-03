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
        
        let brandLabelVM = BasicLabel.ViewModel()
        let yearLabelVM = BasicLabel.ViewModel()
        let vinLabelVM = BasicLabel.ViewModel()
        let milageLabelVM = BasicLabel.ViewModel()
        let segmentVM: BasicSegmentView<RecordType>.GenericViewModel<RecordType>
        let topStackVM: TopView.ViewModel
        let tableVM = BasicTableView.GenericViewModel<Record>()
        let addButtonVM = AlignedButton.ViewModel(buttonVM: .init(title: "Добавить запись"))
        var pageVM: BasicPageController.ViewModel
        var pastRecordsVM: PastRecordsViewController.ViewModel
        var serviceVM: ServicesViewController.ViewModel
        
        @Published var logo: UIImage?
        
        init(car: Car) {
            self.car = car
            
            segmentVM = .init(
                RecordType.allCases,
                selected: .paste,
                titles: { items in items.map({ $0.title}) }
            )
            
            pastRecordsVM = .init(car: car)
            serviceVM = .init()
            
            pageVM = .init(
                controllers: [
                    PastRecordsViewController(vm: pastRecordsVM),
                    ServicesViewController(vm: serviceVM)
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
        }
        
        func readRecords(for car: Car) {
            let records = RealmManager<Record>().read().filter({$0.carID == car.id})
            
            tableVM.setCells(records)
        }
        
        func initFields() {
            brandLabelVM.text = "\(car.brand) \(car.model)"
            yearLabelVM.text = "Год: \(car.year.wrapped)"
            vinLabelVM.text = "VIN: \(car.win.wrapped)"
            milageLabelVM.text = "Пробег: \(car.mileage)"
            
            if let data = car.imageData {
                self.logo = UIImage(data: data)
            }
        }
    }
}
