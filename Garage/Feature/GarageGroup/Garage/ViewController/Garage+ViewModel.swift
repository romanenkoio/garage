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
        
        let tableVM = BasicTableView.GenericViewModel<Car>()
        var addButtonVM: AlignedButton.ViewModel
        var selectedCar: Car?
        var isLocationEnabled = false
        
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
            tableVM.setCells(RealmManager<Car>().read())
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
