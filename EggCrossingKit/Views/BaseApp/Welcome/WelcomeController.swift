
import UIKit
import SnapKit
import CoreData

class WelcomeController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private lazy var settingsButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "settingsButton"),
                                for: .normal)
        view.tag = 1
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
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
    private lazy var startButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "startButton"),
                                for: .normal)
        view.tag = 2
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        addConstraints()
        rotateView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAppData(DataInitialization_EG.url.value)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.5) {
                self.logoImage.snp.updateConstraints { make in
                    make.centerY.equalToSuperview().offset(-80)
                }
                self.startButton.snp.remakeConstraints { make in
                    make.height.equalTo(200)
                    make.centerX.equalToSuperview()
                    make.bottomMargin.equalToSuperview().inset(20)
                }
                self.view.layoutIfNeeded()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.startButton.layer.removeAnimation(forKey: "rotationAnimation")
        }
    }
    func rotateView() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = NSNumber(value: Double.pi * 2) // 360 градусов
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        startButton.layer.add(rotation, forKey: "rotationAnimation")
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(logoImage)
        view.addSubview(logoNameImage)
        
        view.addSubview(settingsButton)
        
        view.addSubview(startButton)
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            openSettings()
            case 2:
            rotateView()
            viewModel.viewAnimate(view: startButton)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.startView()
            }
            UIView.animate(withDuration: 1.0) {
                self.startButton.snp.updateConstraints { make in
                    make.centerX.equalToSuperview().offset(300)
                }
                self.logoImage.alpha = 0.0
                self.logoNameImage.alpha = 0.0
                self.settingsButton.alpha = 0.0
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoImage.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(0)
            make.width.equalToSuperview()
            make.height.equalTo(230)
        }
        logoNameImage.snp.remakeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom)
            make.width.equalTo(250)
            make.height.equalTo(70)
            make.centerX.equalToSuperview()
        }
        settingsButton.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(50)
        }
        startButton.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.left.equalTo(-300)
            make.bottomMargin.equalToSuperview().inset(20)
        }
    }
}
extension WelcomeController {
    func openSettings() {
        let controller = SettingsController()
        navigationController?.pushViewController(controller, animated: false)
    }
    func startView() {
        let controller = SelectController()
        navigationController?.viewControllers = [controller]
    }
}
