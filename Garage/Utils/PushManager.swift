//
//  PushManager.swift
//  Garage
//
//  Created by Illia Romanenko on 20.06.23.
//

import Foundation
import UserNotifications
import UIKit

final class PushManager {
    private let limit = 60
    private let center = UNUserNotificationCenter.current()
    private(set) var isEnable = false {
        didSet {
            reschedule()
        }
    }
    
    static let sh = PushManager()
    
    private init() {}
    
    func removePush(_ id: String) {
        center.removePendingNotificationRequests(withIdentifiers: [id])
        center.removeDeliveredNotifications(withIdentifiers: [id])
    }
    
    func readAll() async -> [UNNotificationRequest] {
        let notification = await center.pendingNotificationRequests()
        return notification
    }
    
    func removeAll() {
        center.removeAllPendingNotificationRequests()
    }
    
    func reschedule() {
        removeAll()
        let isPushUse = SettingsManager.sh.read(.useReminder) ?? true
        if isPushUse {
            scheduleStandart()
            userShedule()
        }
    }
    
    func scheduleStandart() {
        [.conditioner, .tiresFall, .tiresSpring, .windshieldWasher].forEach({ create($0) })
        let isMileageReminder = SettingsManager.sh.read(.mileageReminder) ?? true
        if isMileageReminder {
            create(LocalPush.mileageUpdate)
        }
    }
    
    func userShedule() {
        let reminders: [Reminder] = RealmManager().read().filter({ !$0.isDone })
        reminders.forEach({ create(LocalPush(reminder: $0))})
        
        let documents: [Document] = RealmManager().read().filter({ $0.endDate != nil })
        documents.forEach({ create(LocalPush(document: $0))})
        Task {
            let all = await readAll()
            print("Push count: \(all.count)")
        }
        
    }
    
    func create(_ push: LocalPush) {
        let content = UNMutableNotificationContent()
        content.title = push.title
        if let subtitle = push.subtitle {
            content.subtitle = subtitle
        }
        content.sound = UNNotificationSound.default
        
        var date = push.date
        date.hour = 9
        date.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: push.repeats)
        let request = UNNotificationRequest(identifier: push.id, content: content, trigger: trigger)

        center.add(request)
    }
    
    private func requestPermission() async {
        Task {
            guard let granted = try? await center.requestAuthorization(options: [.sound,.alert,.badge]) else { return }
            self.isEnable = granted
        }
    }
    
    func checkPermission() async {
        Task {
            let settings = await center.notificationSettings()
            switch settings.authorizationStatus {
            case .notDetermined:
                await self.requestPermission()
                self.isEnable = false
            case .authorized, .provisional:
                self.reschedule()
                self.isEnable = true
            default:
                break
            }
        }
    }
}


struct LocalPush {
    var id: String
    var title: String
    var subtitle: String?
    var date: DateComponents
    var repeats: Bool
    
    init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String?,
        date: DateComponents,
        repeats: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.repeats = repeats
    }
    
    init(reminder: Reminder) {
        id = reminder.id
        title = "Вы просили напомнить"
        subtitle = reminder.description
        date = reminder.date.components
        repeats = false
    }
    
    init(document: Document) {
        id = document.id
        title = "Вы просили напомнить"
        subtitle = "Истекает срок действия \(document.rawType)"
        date = document.endDate!.append(.day, value: -15).components
        repeats = false
    }
}

extension LocalPush {
    static let test = LocalPush(
        id: "tires.test",
        title: "Просто хотим напомнить",
        subtitle: "Test",
        date: Date().append(.minute, value: 2).components,
        repeats: true
    )
    
    static let tiresSpring = LocalPush(
        id: "tires.spring",
        title: "Просто хотим напомнить",
        subtitle: "Скоро станет тепло, запланируйте смену шин!",
        date: DateComponents(month: 4, day: 15, hour: 12, minute: 0),
        repeats: true
    )
    
    static let tiresFall = LocalPush(
        id: "tires.fall",
        title: "Просто хотим напомнить",
        subtitle: "Скоро станет прохладно, запланируйте смену шин!",
        date: DateComponents(month: 10, day: 10, hour: 12, minute: 0),
        repeats: true
    )
    
    static let windshieldWasher = LocalPush(
        id: "windshield.washer",
        title: "Просто хотим напомнить",
        subtitle: "Заранее заменяйте стекломывательную жидкость",
        date: DateComponents(month: 10, day: 5, hour: 12, minute: 0),
        repeats: true
    )
    
    static let conditioner = LocalPush(
        id: "conditioner",
        title: "Просто хотим напомнить",
        subtitle: "Подготовьте кондиционер к летнему сезону",
        date: DateComponents(month: 10, day: 5, hour: 12, minute: 0),
        repeats: true
    )
    
    static let mileageUpdate = LocalPush(
        id: "mileage",
        title: "Просто хотим напомнить",
        subtitle: "Обновите пробег автомобилей",
        date: DateComponents(day: 15, hour: 14, minute: 0),
        repeats: true
    )
}
