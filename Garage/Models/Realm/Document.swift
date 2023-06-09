//
//  Document.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import Foundation

final class Document: Object {
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
}

extension Document {
    var type: DocumentType {
        get { return DocumentType(from: rawType) }
        set { rawType = newValue.title }
    }
}
