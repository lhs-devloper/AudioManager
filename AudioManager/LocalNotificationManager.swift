import Foundation
import UserNotifications

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission() -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    //we have permission!
                }
            }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    func schedule() -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    
    func scheduleNotifications() -> Void {
        for notification in notifications {
            //🗓️ 날짜 설정
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.weekday = 4 // Wednesday
            dateComponents.hour = 19 // 14:00
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = UNNotificationSound.default
            content.subtitle = "약 먹을 시간이에요.💊"
            content.body = "먹었다고 체크하기"
            content.summaryArgument = "summary argument"
            content.summaryArgumentCount = 40
            
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("scheduling notification with id:\(notification.id)")
            }
        }
    }
    
    
}
