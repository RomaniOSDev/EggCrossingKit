
import UIKit
import SnapKit

class ScoreController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private lazy var closeButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "closeView"), for: .normal)
        view.tag = 1
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private let scoreViewImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "scoreViewImage")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private let quizResult: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(named: "brownColorCustom")
        view.textAlignment = .left
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        return view
    }()
    private let puzzleResult: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(named: "brownColorCustom")
        view.textAlignment = .left
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.2
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        addConstraints()
        let quizValue = UserDefaults.standard.integer(forKey: UserDefaultsKeys.quizResult.key)
        let puzzleValue = UserDefaults.standard.integer(forKey: UserDefaultsKeys.puzzleResults.key)
        quizResult.text = "\(quizValue)/3"
        puzzleResult.text = "\(puzzleValue)/16"
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(closeButton)
        view.addSubview(scoreViewImage)
        view.addSubview(quizResult)
        view.addSubview(puzzleResult)
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            navigationController?.popViewController(animated: false)
            case 2:
            break
        default:
            break
        }
    }
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.right.equalToSuperview().inset(15)
            make.width.height.equalTo(50)
        }
        scoreViewImage.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(20)
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        if viewModel.isOldIphoneOrIpad() == true {
            quizResult.font = .systemFont(ofSize: 34, weight: .black)
            puzzleResult.font = .systemFont(ofSize: 34, weight: .black)
            quizResult.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(60)
                make.left.equalTo(scoreViewImage.snp.centerX).offset(30)
                make.height.equalTo(40)
                make.centerY.equalTo(scoreViewImage.snp.centerY).offset(-5)
            }
            puzzleResult.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(60)
                make.left.equalTo(scoreViewImage.snp.centerX).offset(55)
                make.height.equalTo(40)
                make.centerY.equalTo(scoreViewImage.snp.centerY).offset(55)
            }
        } else { // old
            quizResult.font = .systemFont(ofSize: 33, weight: .black)
            puzzleResult.font = .systemFont(ofSize: 33, weight: .black)
            quizResult.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(60)
                make.left.equalTo(scoreViewImage.snp.centerX).offset(30)
                make.height.equalTo(35)
                make.centerY.equalTo(scoreViewImage.snp.centerY).offset(-8)
            }
            puzzleResult.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(55)
                make.left.equalTo(scoreViewImage.snp.centerX).offset(55)
                make.height.equalTo(35)
                make.centerY.equalTo(scoreViewImage.snp.centerY).offset(53)
            }
        }
    }
}
