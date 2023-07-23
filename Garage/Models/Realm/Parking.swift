//
//  Parking.swift
//  Garage
//
//  Created by Illia Romanenko on 23.07.23.
//

import Foundation
import RealmSwift
import CoreLocation

class Parking: Object {
    @Persisted var id: String
    @Persisted var carID: String
    @Persisted var date: Date
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    
    convenience init(
        car: Car,
        coordinate: CLLocation
    ) {
        self.init()
        self.id = UUID().uuidString
        self.carID = car.id
        self.date = Date()
        self.latitude = coordinate.coordinate.latitude
        self.longitude = coordinate.coordinate.longitude
    }
}
