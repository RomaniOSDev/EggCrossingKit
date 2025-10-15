
import UIKit
import SnapKit
import CoreData

class LoadController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    private var isFirst = false
    private let loader = UIActivityIndicatorView()
    private var didTransition = false
    private var startupTask: Task<Void, Never>?

    private enum Outcome { case network, timeout }

    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private let logoImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "appLogo")
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let logoNameImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "appName")
        view.contentMode = .scaleAspectFit
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        isFirst = UserDefaults.standard.bool(forKey: UserDefaultsKeys.firstInit.key)
        setupeSubview()
        addConstraints()
        if isFirst == false {
            UserDefaults.standard.setValue(0, forKey:  UserDefaultsKeys.quizResult.key)
            UserDefaults.standard.setValue(0, forKey:  UserDefaultsKeys.quizResult.key)
            UserDefaults.standard.setValue(true, forKey:  UserDefaultsKeys.firstInit.key)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startStartupFlow()
    }
    deinit {
        loader.stopAnimating()
        startupTask?.cancel()
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(loader)
        loader.color = UIColor(named: "brownColorCustom")
        loader.style = .large
        loader.transform = CGAffineTransform(scaleX: 1.4,
                                             y: 1.4)
        view.addSubview(logoImage)
        view.addSubview(logoNameImage)
    }
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loader.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoNameImage.snp.bottom).offset(20)
        }
        logoImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(130)
        }
        logoNameImage.snp.makeConstraints { make in
            make.width.equalTo(250)
            make.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(-200)
        }
    }
    
    private func transitionToNextScreen() {
        // Переходим к WelcomeController
        let welcomeController = WelcomeController()
        navigationController?.viewControllers = [welcomeController]
    }

    private func startStartupFlow() {
        guard startupTask == nil else { return }
        loader.startAnimating()
        UIView.animate(withDuration: 1.0) {
            self.logoImage.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(230)
            }
            self.logoNameImage.snp.remakeConstraints { make in
                make.top.equalTo(self.logoImage.snp.bottom)
                make.width.equalTo(250)
                make.height.equalTo(70)
                make.centerX.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }

        startupTask = Task { [weak self] in
            guard let self else { return }
            let outcome = await self.firstOutcome(timeoutSeconds: 3)
            await self.animateAndTransition(outcome: outcome)
        }
    }

    private func firstOutcome(timeoutSeconds: UInt64) async -> Outcome {
        await withTaskGroup(of: Outcome?.self) { group in
            group.addTask { [weak self] in
                guard let self else { return nil }
                do {
                    _ = try await NetworkService.shared.getAppData(DataInitialization_EG.url.value)
                    return .network
                } catch {
                    return .network // даже при ошибке не держим пользователя
                }
            }
            group.addTask {
                try? await Task.sleep(nanoseconds: timeoutSeconds * 1_000_000_000)
                return .timeout
            }
            defer { group.cancelAll() }
            for await result in group {
                if let result { return result }
            }
            return .timeout
        }
    }

    @MainActor private func animateAndTransition(outcome: Outcome) async {
        guard didTransition == false else { return }
        didTransition = true
        UIView.animate(withDuration: 0.4, animations: {
            self.logoImage.alpha = 0.0
            self.logoNameImage.alpha = 0.0
        }, completion: { _ in
            self.loader.stopAnimating()
            self.transitionToNextScreen()
        })
    }
}


class SimpleLoaderController: UIViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(named: "brownColorCustom")
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        return indicator
    }()
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    // Добавляем таймер для автоматического закрытия
    private var autoDismissTimer: Timer?
    private let autoDismissTime: TimeInterval = 3.0 // 3 секунды
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        
        // Запускаем таймер для автоматического закрытия
        startAutoDismissTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
        autoDismissTimer?.invalidate()
        autoDismissTimer = nil
    }
    
    deinit {
        autoDismissTimer?.invalidate()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundCustom")
        
        view.addSubview(backgroundImageView)
        view.addSubview(activityIndicator)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func startAutoDismissTimer() {
        autoDismissTimer = Timer.scheduledTimer(withTimeInterval: autoDismissTime, repeats: false) { [weak self] _ in
            self?.dismissLoader()
        }
    }
    
    private func dismissLoader() {
        dismiss(animated: true) {
            print("SimpleLoaderController dismissed automatically")
        }
    }
}
