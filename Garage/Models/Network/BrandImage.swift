//
//  BrandImage.swift
//  Garage
//
//  Created by Illia Romanenko on 8.06.23.
//

import Foundation

//https://46.175.171.150/cars-logos/api/data/

struct BrandImage: Decodable {
    let brand: String
    let logoURL: String
    let smalLogoURL: String
      
    enum CodingKeys: String, CodingKey {
        case brand = "brand_name"
        case logoURL = "logo_full"
        case smalLogoURL = "logo_small"
    }
}
