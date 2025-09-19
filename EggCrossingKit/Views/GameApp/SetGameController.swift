
import UIKit

class SetGameController {
    
    static let shared = SetGameController()
    var navigation: UINavigationController?
    
    func saveGameState_EG(_ state: GameState_EG,
                          link: String? = nil) {
        switch state {
        case .unknown_EG:
            UserDefaults.standard.removeObject(forKey: DataInitialization_EG.linkKey.value)
        case .firstLaunch_EG:
            break
        case .correctlyConfigured_EG:
            if UserDefaults.standard.string(forKey: DataInitialization_EG.linkKey.value) == nil {
                UserDefaults.standard.setValue(link,
                                               forKey: DataInitialization_EG.linkKey.value)
            }
        case .baseGame_EG:
            break
        }
        UserDefaults.standard.set(state.rawValue,
                                  forKey: DataInitialization_EG.stateKey.value)
    }
    func setGameState_EG() -> GameState_EG {
        guard let saveState = UserDefaults.standard.string(forKey: DataInitialization_EG.stateKey.value) else {
            return .firstLaunch_EG
        }
        return GameState_EG(rawValue: saveState) ?? .firstLaunch_EG
    }
//    func openCorrectlyView_EG(_ conversionInfo: [AnyHashable: Any]) {
//        switch setGameState_EG() {
//        case .unknown_EG:
//            openWeb(DataInitialization_EG.privacy.value, true)
//        case .firstLaunch_EG:
//           // setAppsFlyerDataForLink_EG(conversionInfo)
//        case .correctlyConfigured_EG:
//            let correctLink = DataInitialization_EG.correctlyLink.value
//            openWeb(correctLink, false)
//        case .baseGame_EG:
//            openWelcomeView(.baseGame_EG)
//        }
//    }
    
    private func fetchGameLink_EG(_ link: String) {
        guard let url = URL(string: link) else {
            DispatchQueue.main.async {
                self.openWelcomeView(.baseGame_EG,
                                     "Invalid URL")
            }
            return
        }
        let config = URLSessionConfiguration.default // Конфигурация с таймаутом 30 секунд
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error as NSError?,
                error.code == NSURLErrorTimedOut {
                DispatchQueue.main.async {
                    self.openWelcomeView(.firstLaunch_EG,
                                         "Timeout: No response from server in 30 seconds \(error.code)")
                }
                return
            }
            if let error = error {
                DispatchQueue.main.async {
                    self.openWelcomeView(.baseGame_EG,
                                         "Error: \(error.localizedDescription)")
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.openWelcomeView(.baseGame_EG,
                                         "No valid response received")
                }
                return
            }
            if httpResponse.statusCode == 404 {
                DispatchQueue.main.async {
                    self.openWelcomeView(.baseGame_EG,
                                         "Error: \(httpResponse.statusCode)")
                }
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.openWelcomeView(.baseGame_EG,
                                         "Server error: \(httpResponse.statusCode)")
                }
                return
            }
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data,
                                                                options: []) {
                    DispatchQueue.main.async {
                        self.openWelcomeView(.baseGame_EG,
                                             "Error parsing JSON \(json)")
                    }
                    return
                }
            }
            
            if let finalURL = httpResponse.url?.absoluteString {
                DispatchQueue.main.async {
                    self.openWeb(finalURL, false)
                    self.saveGameState_EG(.correctlyConfigured_EG,
                                          link: finalURL)
                }
            } else {
                DispatchQueue.main.async {
                    self.openWelcomeView(.baseGame_EG,
                                         "No redirect URL available")
                }
            }
        }
        task.resume()
    }
}
extension SetGameController {
    private func openWeb(_ url: String?,
                         _ isPolicy: Bool) {
        let vc = WebController()
        vc.isPolicy = isPolicy
        vc.loadURL(url ?? DataInitialization_EG.privacy.value)
        navigation?.viewControllers = [vc]
    }
    func openWelcomeView(_ state: GameState_EG,
                         _ error: String? = nil) {
        print("❌ \(error ?? "no error")")
        saveGameState_EG(state)
        let controller = WelcomeController()
        navigation?.viewControllers = [controller]
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        targetNotification_EG(userInfo)
        completionHandler()
   }
   func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       let userInfo = notification.request.content.userInfo
       targetNotification_EG(userInfo)
       completionHandler([])
   }
    private func targetNotification_EG(_ userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [AnyHashable: Any] {
            if let category = aps["category"] as? String {
                print("category: \(category)")
                
            }
            if let targetContentID = aps["target-content-id"] as? String {
                print("targetContentID: \(targetContentID)")
                if gameInitializad.setGameState_EG() == .correctlyConfigured_EG {
                   
                }
            }
        }
        if let custom = userInfo["custom"] as? [AnyHashable: Any],
           let aDict = custom["a"] as? [AnyHashable: Any] {
            if let value = aDict["custom_actions"] as? String {
                switch notificationResponse(value) {
                case .none_EG:
                    break
                case .directToWeb_EG:
                    if gameInitializad.setGameState_EG() == .baseGame_EG {
                        gameInitializad.saveGameState_EG(.firstLaunch_EG)
                       
                    }
                case .second_EG:
                    break
                case .third_EG:
                    break
                }
            }
        }
    }
    private func notificationResponse(_ value: String?) -> CustomNotification_EG {
        return CustomNotification_EG.fromValye_EG(value)
    }
}
