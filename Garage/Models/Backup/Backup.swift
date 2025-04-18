//
//  Backup.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import Foundation

class Backup: Codable {
    let date: Date
    let cars: [Car]
    let documents: [Document]
    let servises: [Service]
    let records: [Record]
    let fuelRecords: [FuelRecord]
    let photos: [Photo]
    let reminders: [Reminder]
    
    init() {
        self.date = Date()
        self.cars = RealmManager().read()
        self.documents = RealmManager().read()
        self.servises = RealmManager().read()
        self.records = RealmManager().read()
        self.fuelRecords = RealmManager().read()
        self.photos = RealmManager().read()
        self.reminders = RealmManager().read()
    }
    
    func saveCurrent() {
        self.cars.forEach { RealmManager().write(object: $0) }
        self.documents.forEach { RealmManager().write(object: $0) }
        self.servises.forEach { RealmManager().write(object: $0) }
        self.records.forEach { RealmManager().write(object: $0) }
        self.fuelRecords.forEach { RealmManager().write(object: $0) }
        self.photos.forEach { RealmManager().write(object: $0) }
        self.reminders.forEach { RealmManager().write(object: $0) }
    }
}
