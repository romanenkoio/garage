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
        
        let tableVM = BasicTableView.GenericViewModel<Record>()
        let addButtonVM = AlignedButton.ViewModel(buttonVM: .init(title: "Добавить запись"))
        
        @Published var logo: UIImage?
        
        init(car: Car) {
            self.car = car
            
            segmentVM = .init(
                RecordType.allCases,
                selected: .future,
                titles: { items in items.map({ $0.title}) }
            )
            super.init()
            initFields()
        }
        
        func readCar() {
            guard let car = RealmManager<Car>().read().first(where: { $0.id == car.id }) else { return }
            self.car = car
            self.initFields()
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
