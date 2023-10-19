//
//  StatisticCellType.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 17.09.23.
//

import Foundation

enum StatisticCellType {
    case averageSum(records: [Record])
    case averageSumPerYear(records: [Record])
    case averageFuelConsump(record: [FuelRecord])
    case averageFuelConsumpPerYear(record: [FuelRecord])
    case mostFreqOperation(records: [Record])
    case mostExpensioveOperation(records: [Record])
    case mostCheapestOpearation(records: [Record])
    
    var statValue: StatisticModel {
        switch self {
            case .averageSum(let records):
                guard let firstRecordDate = records.min(by: {$0.date < $1.date})?.date,
                      let monthsFromFirstRecord = Calendar.current.dateComponents([.month], from: firstRecordDate, to: Date()).month
                else { return (nil, nil, "") }
                
                let monthCountIsZero = monthsFromFirstRecord == 0
                let sum = records.map({$0.cost ?? 0}).reduce(0, +) / (monthCountIsZero ? 1 : monthsFromFirstRecord)
                let description = "Средние траты за месяц"
                
                return (nil, "\(sum)".appendCurrency(), description)
            case .averageSumPerYear(records: let records):
                let isCurrentYearRecords = Calendar.current.component(.year, from: Date()) == records.first?.date.getDateComponent(.year)
                let currentMonth = Calendar.current.component(.month, from: Date())
                
                let sum = records.map({$0.cost ?? 0}).reduce(0, +)
                
                let averageSum = isCurrentYearRecords ? sum / currentMonth : sum / 12
                let description = "Средние траты за месяц"
        
                return (nil, "\(averageSum)".appendCurrency(), description)
                
            case .averageFuelConsump(record: let records):
                guard let firstRecordDate = records.min(by: {$0.date < $1.date})?.date,
                      let monthsFromFirstRecord = Calendar.current.dateComponents([.month], from: firstRecordDate, to: Date()).month
                else { return (nil, "Нет данных за период", "Внесите данные о заправках") }
                let monthCountIsZero = monthsFromFirstRecord == 0
                let sum = records.map({$0.cost ?? 0}).reduce(0, +) / (monthCountIsZero ? 1 : monthsFromFirstRecord)
                let description = "Средний расход на топлвио за месяц"
                
                return (nil, "\(sum)".appendCurrency(), description)
                
            case .averageFuelConsumpPerYear(record: let records):
                let isCurrentYearRecords = Calendar.current.component(.year, from: Date()) == records.first?.date.getDateComponent(.year)
                let currentMonth = Calendar.current.component(.month, from: Date())
                
                let sum = records.map({$0.cost ?? 0}).reduce(0, +)
                
                let averageSum = isCurrentYearRecords ? sum / currentMonth : sum / 12
                let description = "Средний расход на топлвио за месяц"
                
                guard averageSum != 0 else {
                    return (nil, "Нет данных за период", "Внесите данные о заправках")
                }
        
                return (nil, "\(averageSum)".appendCurrency(), description)
                
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
