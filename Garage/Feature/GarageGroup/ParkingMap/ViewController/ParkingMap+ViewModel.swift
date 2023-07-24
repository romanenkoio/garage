//
//  ParkingMap+ViewModel.swift
//  Garage
//
//  Created by Illia Romanenko on 24.07.23.
//  
//

import UIKit

extension ParkingMapViewController {
    final class ViewModel: BasicViewModel {
        
        var parking: Parking?
        
        init(car: Car) {
            parking = RealmManager<Parking>().read().first(where: { $0.carID == car.id })
        }
    }
}
