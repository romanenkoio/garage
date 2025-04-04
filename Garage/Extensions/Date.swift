//
//  Date.swift
//  Garage
//
//  Created by Illia Romanenko on 20.06.23.
//

import Foundation

extension Date {
    func toString(_ formatType: FormatTypes) -> String {
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = formatType.rawValue
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func append(_ component: Calendar.Component, value: Int = 1) -> Date {
        guard let date = Calendar.current.date(byAdding: component, value: value, to: self) else {
            fatalError("Failed adding `\(component)` \(value) to date \(self)")
        }
        return date
    }
    
    func getDateComponent(_ component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self).value(for: component)
    }
    
    func daysBetween(date: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: self, to: date).day
    }
    
    func monthName() -> String {
        let df = DateFormatter()
        df.dateFormat = "MMMM"
        return df.string(from: self)
    }

    var withoutTime: Date {
        let calender = Calendar.current
        var dateComponents = calender.dateComponents([.day, .month, .year], from: self)
        dateComponents.timeZone = .current
        guard let date = calender.date(from: dateComponents) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    var components: DateComponents {
        return Calendar.current.dateComponents([.day, .month, .year], from: self)
    }
    
    var recordComponents: DateComponents {
        return Calendar.current.dateComponents([.month, .year], from: self)
    }
}
