//
//  StatisticType.swift
//  Garage
//
//  Created by Vlad Kulakovsky  on 22.08.23.
//

import Foundation

enum StatisticCellType {
    case averageSumPerYear(car: Car)
    case mostFrequentOperation(car: Car)
    case mostExpensiveOperation(car: Car)
    case mostCheapetsOperation(car: Car)
    case mostExpensioveOperationPerYear(car: Car)
    case mostCheapestOperationPerYear(car: Car)
    
    var record: [Int?: Record?]? {
        switch self {
            case .mostExpensiveOperation(let car):
                let mostExpensiveOperation = car.records.max(by: {$0.cost ?? 0 < $1.cost ?? 0})
                
                return [nil: mostExpensiveOperation]
            case .mostCheapetsOperation(let car):
                let mostCheapestOperation = car.records.max(by: {$0.cost ?? 0 > $1.cost ?? 0})
                
                return [nil: mostCheapestOperation]
            case .mostExpensioveOperationPerYear(let car):
                let mostExpensiveOperationPerYear = Dictionary(
                        grouping: car.records,
                        by: { $0.date.components.year })
                    .mapValues({$0.max(by: {$0.cost ?? 0 < $1.cost ?? 0})})
                
                return mostExpensiveOperationPerYear
                
            case .mostCheapestOperationPerYear(let car):
                let mostCheapestOperationPerYear = Dictionary(
                        grouping: car.records,
                        by: { $0.date.components.year })
                    .mapValues({$0.max(by: {$0.cost ?? 0 > $1.cost ?? 0})})
                
                return mostCheapestOperationPerYear
                
            default: return nil
        }
    }
    
    var header: String {
        switch self {
            case .averageSumPerYear(_):                 return "Среднее за год"
            case .mostFrequentOperation(_):             return "Cамая популярная операция"
            case .mostExpensiveOperation(_):            return "Cамая дорогая операция за все время"
            case .mostCheapetsOperation(_):             return "Самая дешевая операция за все время"
            case .mostExpensioveOperationPerYear(_):    return "Самая дорогая операция за год"
            case .mostCheapestOperationPerYear(_):      return "Самая дешевая операция за год"
        }
    }
    
    var valueOperation: [Int?: String]? {
        switch self {
            case .mostFrequentOperation(let car):
                guard let mostFrequentOperation = (Dictionary(
                    grouping: car.records.map({$0.short}),
                    by: {$0})
                    .max {$0.1.count < $1.1.count}?.key) else { return nil }
                
                return [nil: mostFrequentOperation]
            default: return nil
        }
    }
    
    var valueSum: [Int?: Int]? {
        switch self {
            case .averageSumPerYear(let car):
                let averageSumPerYear = Dictionary(
                    grouping: car.records,
                    by: { $0.date.components.year })
                    .mapValues({$0.map({$0.cost ?? 0}).reduce(0, +) / 12})
                
                return averageSumPerYear
                
            default: return nil
        }
    }
}
