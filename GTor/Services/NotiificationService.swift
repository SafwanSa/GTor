//
//  NotiificationService.swift
//  GTor
//
//  Created by Safwan Saigh on 12/08/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService {
    static var shared = NotificationService()
    
    
    func sendRequest(completion: @escaping (Result<Bool, Error>)->()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (response, err) in
            if let error = err {
                completion(.failure(error))
                return
            }
            completion(.success(response))
        }
    }
    
    func setNotification(on date: Date, at time: Date, task: Task) {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minutes = calendar.component(.minute, from: time)
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        sendRequest { (result) in
            switch result {
            case .failure(let error):
                print("Error sending request: ", error.localizedDescription)
            case .success(let response):
                print("User responded with: ", response)
                let content = UNMutableNotificationContent()
                content.title = NSLocalizedString("doThis", comment: "")
                content.subtitle = NSLocalizedString("itIsTime", comment: "") + ": " + task.title
                content.sound = UNNotificationSound.default
                // Create the date component
                let components = DateComponents(calendar: .current, timeZone: .current,
                                                year: year,
                                                month: month,
                                                day: day,
                                                hour: hour,
                                                minute: minutes,
                                                second: 00)
                // show this notification five seconds from now
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

                // choose a random identifier
                let request = UNNotificationRequest(identifier: task.id.description, content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    
    func deleteNotification(taskUID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskUID.uuidString])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [taskUID.uuidString])
    }
}
