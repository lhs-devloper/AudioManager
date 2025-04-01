import Foundation
import AVFoundation
import UserNotifications

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {

    private var notificationCenter: UNUserNotificationCenter?
    
    override init() {
        super.init()
        
        notificationCenter = UNUserNotificationCenter.current();
        notificationCenter?.delegate = self;
        
        requestNotificationAuthorization()
//        sendNotification(title: "ㅇㅇ", body: "ㅇㅇ", seconds: 2.0)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

        notificationCenter?.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func sendNotification(title: UnsafePointer<CChar>,
                          body: UnsafePointer<CChar>,
                          seconds: Double) {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = String(cString: title)
        notificationContent.body = String(cString: body)
        
//        notificationContent.title = title
//        notificationContent.body = body

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)

        notificationCenter?.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
