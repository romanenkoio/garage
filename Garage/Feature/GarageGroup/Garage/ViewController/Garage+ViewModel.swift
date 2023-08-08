//
//  Garage+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//  
//

import UIKit
import CoreLocation

extension GarageViewController {
    final class ViewModel: BasicControllerModel {
        enum Cells {
            case banner
            case car
            case addCar
        }
        
        let tableVM = BasicTableView.SectionViewModel<Cells>()
        var addButtonVM: AlignedButton.ViewModel
        var selectedCar: Car?
        var isLocationEnabled = false
        var cars: [Car] = .empty
        
        override init() {
            addButtonVM = .init(buttonVM: .init(title: "Добавить машину".localized))
            
            switch LocationManager.shared.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                isLocationEnabled = true
            default:
                break
            }
            
            super.init()
            readCars()
            
            tableVM.setupEmptyState(
                labelVM: .init(.text("Ваш гараж пуст".localized)),
                sublabelVM: .init(.text("Добавьте машину для \nначала работы".localized)),
                addButtonVM: addButtonVM.buttonVM,
                image: UIImage(named: "car_placeholder")
            )
        }
        
        func readCars() {
            var cells = [[Cells]]()
    
            self.cars = RealmManager<Car>().read()
            if cars.isEmpty {
                tableVM.setCells(.empty)
                return
            }
            let carCells = [Cells](repeating: .car, count: cars.count)
                
            cells.append(carCells)
            cells.append([.addCar])
            
            if !Environment.isPrem {
                cells.insert([.banner], at: 0)
            }
            
            tableVM.setCells(cells)
        }
        
        func setParkingMode(from location: CLLocation) {
            guard let selectedCar else { return }
            RealmManager().write(object: Parking(car: selectedCar, coordinate: location))
        }
        
        func removeParkingLocation() {
            guard let selectedCar else { return }
            let parkings = RealmManager<Parking>().read().filter({ $0.carID == selectedCar.id})
            parkings.forEach({ RealmManager().delete(object: $0 )})
        }
    }
}
