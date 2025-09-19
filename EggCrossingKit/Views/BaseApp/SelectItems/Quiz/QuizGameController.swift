
import UIKit
import SnapKit

class QuizGameController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    var mode: QuizMode = .easy
    private var data: [Easy] = []
    private var currentIndex: Int = 0
    private var result = 0
    
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
        view.setBackgroundImage(UIImage(named: "backButton"), for: .normal)
        view.tag = 1
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private let headerImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "questionsImage")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private lazy var questionsTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return view
    }()
    private var answerCustomView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.axis = .vertical
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        addConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let allQuizData = viewModel.setResponseData()?.quize
        switch mode {
        case .easy:
            data = allQuizData?.easy ?? []
        case .medium:
            data = allQuizData?.medium ?? []
        case .hard:
            data = allQuizData?.hard ?? []
        }
        setupeAnswerView()
        questionsTitle.text = data[currentIndex].questions
    }
    private func setupeAnswerView() {
        let answer = data[currentIndex].answers
        answerCustomView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        answer.enumerated().forEach { index, data in
            let view = AnswerCustomView()
            view.stackView.isUserInteractionEnabled = true
            view.answerView.tag = index
            view.configure(title: data,
                           correctAnswer: self.data[currentIndex].currentIndex)
            view.didSelectAnswer = { [weak self] answerIndex in
                view.stackView.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5 ) { [weak self] in
                    guard let self else { return }
                    if currentIndex < self.data.count - 1 {
                        currentIndex += 1
                        questionsTitle.text = self.data[currentIndex].questions
                        setupeAnswerView()
                       
                        if answerIndex == self.data[currentIndex].currentIndex {
                            result += 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                            view.stackView.isUserInteractionEnabled = true
                        }
                    } else {
                        openResultView()
                        saveResult()
                    }
                }
            }
            answerCustomView.addArrangedSubview(view)
        }
    }
    private func saveResult() {
        let myValuy = UserDefaults.standard.integer(forKey:  UserDefaultsKeys.quizResult.key)
        if result > myValuy {
            UserDefaults.standard.setValue(result,
                                           forKey:  UserDefaultsKeys.quizResult.key)
        }
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(headerImage)
        view.addSubview(closeButton)
        view.addSubview(questionsTitle)
        view.addSubview(answerCustomView)
        
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
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(15)
            make.width.equalTo(36)
            make.height.equalTo(28)
        }
        headerImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualTo(backgroundImageView.snp.centerY)
        }
        questionsTitle.snp.makeConstraints { make in
            make.top.equalTo(headerImage.snp.centerY)
            make.width.equalTo(self.view.frame.width / 1.6)
            make.centerX.equalToSuperview().offset(12)
            make.bottom.equalTo(headerImage.snp.centerY).offset(120)
        }
        if viewModel.isOldIphoneOrIpad() == false {
            questionsTitle.snp.updateConstraints { make in
                make.width.equalTo(self.view.frame.width / 1.8)
                make.bottom.equalTo(headerImage.snp.centerY).offset(95)
            }
        }
        answerCustomView.snp.makeConstraints { make in
            make.top.equalTo(headerImage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(100)
            make.bottomMargin.equalToSuperview().inset(20)
        }
    }
}
extension QuizGameController {
    func openResultView() {
        let controller = ResultView()
        controller.result = result
        navigationController?.pushViewController(controller, animated: false)
    }
}
