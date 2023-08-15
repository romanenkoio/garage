//
//  Document.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import Foundation
import UIKit

final class Document: Object, Codable {
    @Persisted var id: String
    @Persisted var rawType: String
    @Persisted var startDate: Date?
    @Persisted var endDate: Date?
    @Persisted var photo: Data?
    
    convenience init(
        rawType: String,
        startDate: Date? = nil,
        endDate: Date? = nil,
        photo: Data? = nil
    ) {
        self.init()
        self.id = UUID().uuidString
        self.rawType = rawType
        self.startDate = startDate
        self.endDate = endDate
        self.photo = photo
    }
    
    private var days: Int? {
        guard let endDate else { return nil }
        return Date().daysBetween(date: endDate)
    }
    
    var isOverdue: (status: Bool?, days: Int?) {
        guard let days else { return (nil, nil) }
        return (days < 20, days)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case rawType
        case startDate
        case endDate
        case photo
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(rawType, forKey: .rawType)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(photo, forKey: .photo)
    }
}

extension Document {
    var photos: [UIImage] {
        let photoData = RealmManager<Photo>()
            .read()
            .filter({ $0.documentId == self.id })
        let images = photoData.compactMap({UIImage(data: $0.image)})
        return images
    }
}
