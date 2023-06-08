//
//  Model.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

struct Model: Decodable, Equatable {
    let makeID: Int
    let makeName: String
    let modelID: Int
    let modelName: String
    
    enum CodingKeys: String, CodingKey {
        case makeID = "Make_ID"
        case makeName = "Make_Name"
        case modelID = "Model_ID"
        case modelName = "Model_Name"
    }
}
