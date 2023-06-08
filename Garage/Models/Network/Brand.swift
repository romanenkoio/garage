//
//  Brands.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

struct Brand: Decodable, Equatable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Make_ID"
        case name = "Make_Name"
    }
}
