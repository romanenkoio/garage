//
//  Photo.swift
//  Garage
//
//  Created by Illia Romanenko on 11.06.23.
//

import Foundation
import RealmSwift
import UIKit

final class Photo: Object, Codable {
    @Persisted var id: String
    @Persisted var documentId: String?
    @Persisted var recordId: String?
    @Persisted var carId: String?
    @Persisted var image: Data
    
    
    var converted: UIImage? {
        return UIImage(data: image)
    }
    
    convenience init(
        _ document: Document,
        image: Data
    ) {
        self.init()
        self.id = UUID().uuidString
        self.documentId = document.id
        self.image = image
    }
    
    convenience init(
        _ record: Record,
        image: Data
    ) {
        self.init()
        self.id = UUID().uuidString
        self.recordId = record.id
        self.image = image
    }
    
    convenience init(
        _ car: Car,
        image: Data
    ) {
        self.init()
        self.id = UUID().uuidString
        self.carId = car.id
        self.image = image
    }
}
