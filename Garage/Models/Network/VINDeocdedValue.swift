//
//  VINDeocdeValue.swift
//  Garage
//
//  Created by Illia Romanenko on 9.06.23.
//

import Foundation

struct VINDeocdedValue: Decodable, Equatable {
    let value: String?
    let valueID: String?
    let type: String
    let variableID: Int
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case valueID = "ValueId"
        case type = "Variable"
        case variableID = "VariableId"
    }
}

enum VINDecodedType: String, CaseIterable {
    case make = "Make"
    case model = "Model"
    case year = "Model Year"
}

