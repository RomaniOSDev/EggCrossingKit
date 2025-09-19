
import UIKit
import SnapKit

class PuzzleResultView: UIViewController {
    
    let viewModel = BaseViewModel.shared
    var result = 0
    var seconds: Int = 0
    var mode = PuzzleMode.yeasy
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private let timerTitle: UILabel = {
        let view = UILabel()
        view.text = "0:00"
        view.font = .systemFont(ofSize: 30, weight: .bold)
        view.textAlignment = .center
        view.textColor = UIColor(named: "brownColorCustom")
        return view
    }()
    private let completedImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "completedImagePuzzle")
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
        setTimeTitle()
    }
    private func setTimeTitle() {
        let minutes = seconds / 60
        let secs = seconds % 60
        let formatted = String(format: "%d:%02d", minutes, secs)
        timerTitle.text = formatted
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(timerTitle)
        view.addSubview(completedImage)
        view.addSubview(playAgain)
        view.addSubview(backToMenu)
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            navigationController?.popToRootViewController(animated: false)
            case 2:
            let data = puzzleSection[0].items
            openPuzzle(mode: mode,
                       data: data,
                       index: 0)
        default:
            break
        }
    }
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        timerTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(33)
            make.width.equalTo(75)
        }
        completedImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
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
extension PuzzleResultView {
    func openPuzzle(mode: PuzzleMode,
                    data: [PuzzleData]?,
                    index: Int?) {
        switch mode {
        case .yeasy:
            let controller = PuzzlessYeasyController()
            controller.data = data
            controller.index = index ?? 0
            navigationController?.pushViewController(controller, animated: false)
        case .hard:
            let controller = PuzzlessHardController()
            controller.data = data
            controller.index = index ?? 0
            navigationController?.pushViewController(controller, animated: false)
        }
    }
}
