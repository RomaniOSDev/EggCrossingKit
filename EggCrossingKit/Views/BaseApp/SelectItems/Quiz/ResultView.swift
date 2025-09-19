
import UIKit
import SnapKit

class ResultView: UIViewController {
    
    let viewModel = BaseViewModel.shared
    var result = 0
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private let completedImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "completedImage")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    
    private lazy var playAgain: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "playAgainButton"), for: .normal)
        view.tag = 2
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private lazy var backToMenu: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "backToMenuButton"), for: .normal)
        view.tag = 1
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        addConstraints()
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(completedImage)
        view.addSubview(playAgain)
        view.addSubview(backToMenu)
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            navigationController?.popToRootViewController(animated: false)
            case 2:
            navigationController?.popViewController(animated: false)
        default:
            break
        }
    }
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        completedImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualTo(backgroundImageView.snp.centerY)
        }
        playAgain.snp.makeConstraints { make in
            make.height.equalTo(75)
            make.leading.trailing.equalToSuperview().inset(45)
            make.bottom.equalTo(backToMenu.snp.top).inset(-15)
        }
        backToMenu.snp.makeConstraints { make in
            make.height.equalTo(75)
            make.leading.trailing.equalToSuperview().inset(45)
            make.bottomMargin.equalToSuperview().inset(30)
        }
    }
}
