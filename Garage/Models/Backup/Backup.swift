//
//  Backup.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import Foundation

class Backup: Encodable {
    let cars: [Car]
    let documents: [Document]
    let servises: [Service]
    let records: [Record]
    let photos: [Photo]
    
    init(
        cars: [Car],
        documents: [Document],
        servises: [Service],
        records: [Record],
        photos: [Photo]
    ) {
        self.cars = cars
        self.documents = documents
        self.servises = servises
        self.records = records
        self.photos = photos
    }
}
