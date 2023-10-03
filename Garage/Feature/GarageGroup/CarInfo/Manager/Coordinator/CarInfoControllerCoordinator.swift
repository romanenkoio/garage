//
//  CarInfoControllerCoordinator.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//  
//

import UIKit

enum CarInfoNavigationRoute: Routable {
    case createRecord(Car)
    case editRecord(Car, Recordable)
    case createFuelRecord(Car)
    case editReminder(Car, Reminder)
    case createReminder(Car)
    case edit(Car)
    case createRecordFromReminder(Car, Reminder)
    case statistic(Car)
}

class CarInfoControllerCoordinator: BasicCoordinator {
    // - Init
    override init(vc: BasicViewController) {
        super.init(vc: vc)
    }
    
    private func castFromRecordableController(_ car: Car, record: Recordable) -> BasicViewController {
        switch record {
            case let record as Record:
                return CreateRecordViewController(vm: .init(car: car, mode: .edit(object: record)))
            case let fuelRecord as FuelRecord:
                return CreateFuelRecordViewController(vm: .init(car: car, mode: .edit(object: fuelRecord)))
            default: return BasicViewController()
        }
    }
    
    override func navigateTo(_ route: Routable) {
        if let route = route as? CarInfoNavigationRoute {
            switch route {
            case .createRecord(let car):
                let controller = CreateRecordViewController(vm: .init(car: car, mode: .create))
                vc.push(controller)
            case .edit(let car):
                let vm = CreateCarViewController.ViewModel(mode: .edit(object: car))
                vm.succesCreateCompletion = { [weak self] in
                    guard let self else { return }
                    navigateTo(CommonNavigationRoute.close)
                }
                let controller = CreateCarViewController(vm: vm)
                vc.push(controller)
            case .createReminder(let car):
                let controller = CreateReminderViewController(vm: .init(car: car, mode: .create))
                vc.push(controller)
            case .editRecord(let car, let record):
                    vc.push(castFromRecordableController(car, record: record))
            case .editReminder(let car, let reminder):
                let controller = CreateReminderViewController(vm: .init(car: car, mode: .edit(object: reminder)))
                vc.push(controller)
            case .createRecordFromReminder(let car, let reminder):
                let controller = CreateRecordViewController(vm: .init(car: car, mode: .createFrom(reminder)))
                vc.push(controller)
            case .statistic(let car):
                let controller = StatisticPagesViewController(vm: .init(car: car))
                vc.push(controller)
                case .createFuelRecord(let car):
                    let controller = CreateFuelRecordViewController(vm: .init(car: car, mode: .create))
                    vc.push(controller)
            }
        } else {
            super.navigateTo(route)
        }
    }
}
