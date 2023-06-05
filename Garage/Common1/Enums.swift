//
//  Enums.swift
//  Logogo
//
//  Created by Illia Romanenko on 18.05.23.
//

import Foundation

enum Specialization: String, CaseIterable {
    case psychologist
    case speechTherapist
    case speechTherapyVocals
    
    var title: String {
        switch self {
        case .psychologist:             return "Психолог"
        case .speechTherapist:          return "Логопед-дефектолог"
        case .speechTherapyVocals:      return "Специалист по логовокалу"
        }
    }
}

enum LessonTime: String, CaseIterable {
    case a = "8:10 - 8:50"
    case b = "9:00 - 09:40"
    case c = "9:50 - 10:30"
    case d = "10:40 - 11:20"
    case e = "11:30 - 12:10"
    case f = "12:20 - 13:00"
    case g = "13:10 - 13:50"
    case h = "14:00 - 14:40"
    case i = "15:00 - 15:40"
    case j = "15:50 - 16:30"
    case k = "16:40 - 17:20"
    case l = "17:30 - 18:10"
    case m = "18:20 - 19:00"
    case n = "19:10 - 19:50"
}

enum ValidationMode {
    case none
    case afterFocus
    case onEditing
}

enum LessonStatus: String, CaseIterable {
    case none
    case done
    case cancelled
    case moved
}

enum CancelReason {
    case ill
    case none
}

enum LessonType: String, CaseIterable {
    case future = "Будущие"
    case paste = "Прошлые"
}

enum LessonSpecialization: String, CaseIterable {
    case lesson
    case sensoric
    case diagnostic
    
    var title: String {
        switch self {
        case .lesson:       return "Занятие"
        case .sensoric:     return "Сенсорная интеграция"
        case .diagnostic:   return "Диагностика"
        }
    }
}

enum CommonNavigationRoute: Routable {
    case close
    case closeToRoot
}
