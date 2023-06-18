//
//  EntityStatus.swift
//  Garage
//
//  Created by Illia Romanenko on 18.06.23.
//

import Foundation
import RealmSwift

enum EntityStatus<T: Object>: Equatable {
    case create
    case edit(object: T)
}
