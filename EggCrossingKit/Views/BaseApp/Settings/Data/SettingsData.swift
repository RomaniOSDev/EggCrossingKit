

import UIKit

enum SettingsItems {
    case rate
    case result
    case privacy
    case info
}

struct SettingsData {
    let type: SettingsItems
    let preview: UIImage?
}

let settingsData: [SettingsData] = [.init(type: .rate,
                                          preview: UIImage(named: "settingsItem1")),
                                    .init(type: .result,
                                          preview: UIImage(named: "settingsItem2")),
                                    .init(type: .privacy,
                                          preview: UIImage(named: "settingsItem3")),
                                    .init(type: .info,
                                          preview: UIImage(named: "settingsItem4"))]
