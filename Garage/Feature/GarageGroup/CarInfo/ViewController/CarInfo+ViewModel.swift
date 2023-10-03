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
        let carTopInfoVM: CarTopInfoView.ViewModel
        var pageVM: BasicPageController.ViewModel
        var pastRecordsVM: PastRecordsViewController.ViewModel
        var remindersVM: RemindersViewController.ViewModel
        let addButtonVM = FloatingButtonView.ViewModel()
        @Published var pageVCTableView: UITableView?
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
            
            carTopInfoVM = .init(car: self.car)
            super.init()
            
            pastRecordsVM.didLayoutSubviews = {[weak self] tableView in
                self?.pageVCTableView = tableView
            }
            
            remindersVM.didLayoutSubviews = {[weak self] tableView in
                self?.pageVCTableView = tableView
            }
            
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
        
        func initFields() {
            if let photo = car.images.first {
                carTopInfoVM.logoVM.set(from: photo)
                carTopInfoVM.logoVM.mode = .scaleAspectFill
            } else if let data = car.imageData {
                carTopInfoVM.logoVM.image = UIImage(data: data)
                carTopInfoVM.logoVM.mode = .scaleAspectFit
            } else {
                carTopInfoVM.logoVM.image = UIImage(named: "logo_placeholder")
                carTopInfoVM.logoVM.mode = .scaleAspectFit
            }
        }
    }
}
