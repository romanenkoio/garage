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
    
    let sh = PushManager()
    
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
        
    }
    
    func create(_ push: LocalPush) {
        let content = UNMutableNotificationContent()
        content.title = push.title
        if let subtitle = push.subtitle {
            content.subtitle = subtitle
        }
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 61, repeats: push.repeats)
        let request = UNNotificationRequest(identifier: push.id, content: content, trigger: trigger)

        center.add(request)
    }
    
    func requestPermission() async {
        Task { @MainActor in
            guard let granted = try? await center.requestAuthorization(options: [.sound,.alert,.badge]) else { return }
            self.isEnable = granted
        }
    }
    
    private func checkPermission() async {
        Task { @MainActor in
            let settings = await center.notificationSettings()
            switch settings.authorizationStatus {
            case .notDetermined:
                await self.requestPermission()
            case .authorized, .provisional:
                self.reschedule()
            default:
                break
            }
        }
    }
}

extension PushManager {
    struct LocalPush {
        var id: String
        var title: String
        var subtitle: String?
        var date: Date
        var repeats: Bool
        
        init(
            id: String = UUID().uuidString,
            title: String,
            subtitle: String?,
            date: Date,
            repeats: Bool = false
        ) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.date = date
            self.repeats = repeats
        }
    }
}


