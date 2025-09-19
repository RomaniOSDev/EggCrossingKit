
import UIKit
import SnapKit
import CoreData

class LoaderController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    private var isFirst = false
    private let loader = UIActivityIndicatorView()

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 1.0) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.loader.startAnimating()
                }
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
            
            // Переход к следующему экрану после анимации
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.loader.stopAnimating()
                self.transitionToNextScreen()
            }
        }
    }
    deinit {
        loader.stopAnimating()
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
}
