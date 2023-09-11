//
//  FAQType.swift
//  Garage
//
//  Created by Illia Romanenko on 11.09.23.
//

import Foundation

enum FAQType: CaseIterable {

    enum Liquid: CaseIterable {
        case motorOil
        case aTransmissionOil
        case mTransmissionOil
        case coolant
        case breakFluid
        case hydraulicFluid
    }
    
    enum Filters: CaseIterable {
        case fuel
        case air
        case cabin
    }

    enum Electro: CaseIterable {
        case battery
        case sparkPlug
    }
    
    enum Mechanic: CaseIterable {
        case grm
    }
}
