//
//  Reminder.swift
//  Garage
//
//  Created by Illia Romanenko on 18.06.23.
//

import Foundation
import RealmSwift

final class Reminder: Object {
    @Persisted var id: String
    @Persisted var short: String
    @Persisted var comment: String?
    @Persisted var carID: String
    @Persisted var date: Date
    
    convenience init(
        short: String,
        comment: String? = nil,
        carID: String,
        date: Date
    ) {
        self.init()
        self.id = UUID().uuidString
        self.short = short
        self.comment = comment
        self.carID = carID
        self.date = date
    }
    
    func setPush() {
        PushManager.sh.create(LocalPush(reminder: self))
    }
}
