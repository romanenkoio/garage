//
//  Wrapper.swift
//  Garage
//
//  Created by Illia Romanenko on 6.06.23.
//

import Foundation

struct Wrapper<T: Decodable>: Decodable {
    let count: Int?
    let message: String?
    let searchCriteria: String?
    let result: [T]
    
    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case message = "Message"
        case searchCriteria = "SearchCriteria"
        case result = "Results"
    }
}
