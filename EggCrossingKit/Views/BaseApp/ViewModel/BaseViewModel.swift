

import UIKit
import StoreKit

class BaseViewModel {
    
    static let shared = BaseViewModel()
    let network = NetworkService.shared
    var errorStatus: ((NetworkError) -> Void)?
    var getAllQuizData: ((ResnonseData?) -> Void)?
    private var quizData: ResnonseData?
    
    func viewAnimate(view: UIView) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            view.transform = CGAffineTransform(scaleX: 0.95,
                                               y: 0.95)
        }, completion: { finished in
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                view.transform = CGAffineTransform(scaleX: 1,
                                                   y: 1)
            })
        })
    }
    func isOldIphoneOrIpad() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.screen.bounds.height > 800
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            let modelName = UIDevice.current.modelName
            let oldiPadModels = ["iPad4", "iPad5", "iPad6", "iPad7", "iPad8", "iPad2", "iPad3", "Ipad", "iPadOS", "iPad"]
            return !oldiPadModels.contains(where: modelName.contains)
        }
        return true
    }
}
extension BaseViewModel {
    
    func setResponseData() -> ResnonseData? {
        return quizData
    }
    @MainActor func getAppData(_ url: String) {
        Task  {
             do {
                 let data = try await network.getAppData(url)
                 DispatchQueue.main.async { [weak self] in
                     guard let self else { return }
                     quizData = data
                 }
             } catch {
                 DispatchQueue.main.async { [weak self] in
                     self?.network.errorStatus = { [weak self] error in
                         self?.errorStatus?(error)
                     }
                 }
             }
         }
    }
}
// _____________ MARK: - Extension

extension UIView {
    func shakeView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -8.0, 8.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }
}
extension SKStoreReviewController {
    public static func requestRateApplication() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier,
            element in
            guard let value = element.value as? Int8,
                  value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
