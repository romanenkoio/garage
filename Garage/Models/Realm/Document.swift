//
//  Document.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import RealmSwift
import Foundation

final class Document: Object {
    @Persisted var id: Int
    @Persisted var rawType: String
    @Persisted var startDate: Date?
    @Persisted var endDate: Date?
    @Persisted var photo: Data?
}

extension Document {
    var type: DocumentType {
        get { return DocumentType(from: rawType) }
        set { rawType = newValue.title }
    }
}
