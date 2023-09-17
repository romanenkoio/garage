//
//  StatisticCellType.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 17.09.23.
//

import Foundation

enum StatisticCellType {
    case averageSum(records: [Record])
    case mostFreqOperation(records: [Record])
    case mostExpensioveOperation(records: [Record])
    case mostCheapestOpearation(records: [Record])
    
    var statValue: StatisticModel {
        switch self {
            case .averageSum(let records):
                let sum = records.map({$0.cost ?? 0}).reduce(0, +) / 12
                let description = "Средний расход за месяц"
                return (nil, "\(sum)".appendCurrency(), description)
                
            case .mostFreqOperation(let records):
                let mostFrequentRecord =
                Dictionary(
                    grouping: records.map({$0.short}),
                    by: {$0}
                )
                .max {$0.1.count < $1.1.count}?
                .key
                
                let description = "Самая популярная операция"
                return (nil, mostFrequentRecord, description)
                
            case .mostExpensioveOperation(let records):
                guard let mostExpensiveRecord = records.max(by: {$0.cost ?? 0 < $1.cost ?? 0}) else { return (Record(),"", "")}
                
                let description = "Самая дорогая операция"
                return (mostExpensiveRecord, nil, description)
                
            case .mostCheapestOpearation(let records):
                guard let mostCheapestRecord = records.max(by: {$0.cost ?? 0 > $1.cost ?? 0}) else { return (Record(),"", "")}
                
                let description = "Самая дешевая операция"
                return (mostCheapestRecord, nil, description)
        }
    }
}
