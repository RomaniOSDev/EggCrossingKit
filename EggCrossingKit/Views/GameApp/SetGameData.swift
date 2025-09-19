
import Foundation

let applicationID = 6749801154
var gameInitializad = SetGameController.shared

enum DataInitialization_EG {
    case appId
    case appsFlyerKey
    case privacy
    case url
    case offer
    
    
    case stateKey
    case linkKey
    case correctlyLink
    
    var value: String {
        switch self {
        case .appId: return "id\(applicationID)"
        case .appsFlyerKey: return "suQJTxXVai2ULmaTSDrt2W"
        case .privacy: return "https://telegra.ph/Privacy-Policy--Egg-Crossing-08-09"
            
        case .url: return "https://eggskipper.space/qy8g8vDH?sub_id_10=quize"
        case .offer: return "https://eggskipper.space/info?appsflyer_id="
            
        case .stateKey: return "state_Save_EggCrossing"
        case .linkKey: return "link_Save_EggCrossing"
        case .correctlyLink: return UserDefaults.standard.string(forKey: DataInitialization_EG.linkKey.value) ?? ""
        }
    }
}
enum GameState_EG: String {
    case unknown_EG
    case firstLaunch_EG
    case correctlyConfigured_EG
    case baseGame_EG
}

enum OneSignalValue_EG {
    case appID_EG
    
    var key: String {
        switch self {
        case .appID_EG : return "d6684e8b-3b31-4e91-8873-68f0186184ab"
        }
    }
}


enum CustomNotification_EG {
    case none_EG
    case directToWeb_EG
    case second_EG
    case third_EG
    
    var value: String {
        switch self {
        case .none_EG: return ""
        case .directToWeb_EG: return "direct.the.user_web"
        case .second_EG: return ""
        case .third_EG: return ""
        }
    }
    static func fromValye_EG(_ name: String?) -> CustomNotification_EG {
        guard let name else { return .none_EG }
        let lowercasedName = name.lowercased()
        for category in [directToWeb_EG,
                         second_EG,
                         third_EG] {
            if category.value.lowercased() == lowercasedName {
                return category
            }
        }
        return .none_EG
    }
}
