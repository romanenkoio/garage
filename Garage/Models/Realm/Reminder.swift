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
    @Persisted var isDone: Bool
    
    var days: Int? {
        Date().daysBetween(date: date)
    }
    
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
        self.isDone = false
    }
    
    func setPush() {
        PushManager.sh.create(LocalPush(reminder: self))
    }
    
    func completeReminder() {
        PushManager.sh.removePush(self.id)
        RealmManager().update { [weak self] realm in
            try? realm.write({ [weak self] in
                guard let self else { return }
                self.isDone = true
            })
        }
    }
    
    func uncompleteReminder() {
        PushManager.sh.removePush(self.id)
        RealmManager().update { [weak self] realm in
            try? realm.write({ [weak self] in
                guard let self else { return }
                self.isDone = false
                self.setPush()
            })
        }
    }
}
