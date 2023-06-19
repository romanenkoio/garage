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
    @Persisted var comment: String?
    @Persisted var carID: String
    @Persisted var date: String
}
