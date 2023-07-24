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
        let removeParkingButtonVM = AlignedButton.ViewModel(buttonVM: .init(title: "Удалить парковку"))
        
        var parking: Parking?
        unowned let car: Car
        
        init(car: Car) {
            self.car = car
            parking = RealmManager<Parking>().read().first(where: { $0.carID == car.id })
        }
        
        func removeParking() {
            let parkings = RealmManager<Parking>().read().filter({ $0.carID == car.id})
            parkings.forEach({ RealmManager().delete(object: $0 )})
        }
    }
}
