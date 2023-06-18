//
//  DateFormatter+Extension.swift
//  Logogo
//
//  Created by Vlad Kulakovsky  on 1.06.23.
//

import Foundation
enum FormatTypes: String {
    /// Wednesday, Sep 12, 2018
    case EEEEMMMdYYYY = "EEEE, MMM d, yyyy"
    /// 09/12/2018
    case MMddyyyy = "MM/dd/yyyy"
    /// 09-12-2018 14:11
    case MMddyyyyHHmm = "MM-dd-yyyy HH:mm"
    /// 12 September, 2:11
    case dMMMHHmm = "d MMMM, HH:mm"
    /// September 2018
    case MMMMyyyy = "MMMM yyyy"
    /// Wed. 12 September 2018
    case EEdMMMMyyyy = "EE. d  MMMM yyyy"
    /// 12.09.18
    case ddMMyy = "dd.MM.yy"
    /// 14:11
    case HHmm = "HH:mm"
    /// 12-09-2022
    case ddMMyyyy = "dd-MM-yyyy"
    case dd = "dd"
    case E = "E"
}

extension Int {
    func formatData(formatType: FormatTypes) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = formatType.rawValue
        dayTimePeriodFormatter.locale = .current
        let dateString = dayTimePeriodFormatter.string(from: date)
        
        return dateString
    }
    
    func toString() -> String {
        return String(self)
    }
}

extension Date {
    func formatData(formatType: FormatTypes) -> String {
        let date = self
        let dateFormatter = DateFormatter()
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
}

extension String {
    func formatData(formatType: FormatTypes) -> Date {
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterMonth.dateFormat = formatType.rawValue
        guard let date = dateFormatterMonth.date(from: self) else { return Date()}
        
        return date
    }
}

