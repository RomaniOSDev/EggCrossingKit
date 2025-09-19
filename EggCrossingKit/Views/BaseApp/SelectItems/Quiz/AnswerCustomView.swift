
import UIKit
import SnapKit

final class AnswerCustomView: UIView {
    
    let viewModel = BaseViewModel.shared
    var correctAnswer = 0
    var didSelectAnswer: ((Int) -> Void)?
    
   var stackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.layer.cornerRadius = 21
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    var answerView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(UIColor(named: "brownColorCustom"),
                           for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 25,
                                            weight: .bold)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.minimumScaleFactor = 0.2
        view.titleLabel?.textAlignment = .center
        view.setBackgroundImage(UIImage(named: "answerViewImage"), for: .normal)
        return view
    }()
    init() {
        super.init(frame: .zero)
        addSubview()
        setupeConstraints()
        answerView.addTarget(self,
                               action: #selector(tapButton),
                               for: .touchUpInside)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubview() {
        self.addSubview(stackView)
        stackView.addSubview(answerView)
        answerView.alpha = 0.0
    }
    func configure(title: String,
                   correctAnswer: Int) {
        self.correctAnswer = correctAnswer
        answerView.setBackgroundImage(UIImage(named: "answerViewImage"),
                                        for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) { [weak self] in
            self?.answerView.setTitle(title,
                                       for: .normal)
        }
        switch answerView.tag {
        case 0:
            answerView.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
                guard let self else { return }
                showButton(button: answerView,
                           title: title)
            }
        case 1:
            answerView.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) { [weak self] in
                guard let self else { return }
                showButton(button: answerView,
                           title: title)
            }
        case 2:
            answerView.alpha = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 ) { [weak self] in
                guard let self else { return }
                showButton(button: answerView,
                           title: title)
            }
        default:
            break
        }
    }
    private func showButton(button: UIButton,
                            title: String) {
        UIView.transition(with: button,
                          duration: 0.5,
                          options: .transitionFlipFromBottom,
                          animations: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                button.setTitle(title,
                                for: .normal)
            }
        })
    }
    @objc func tapButton(_ sender: UIButton) {
        viewModel.viewAnimate(view: answerView)
        answerView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) { [weak self] in
            guard let self else { return }
            if correctAnswer == sender.tag {
                answerView.setBackgroundImage(UIImage(named: "answerViewImageY"), // yes
                                                for: .normal)
            } else {
                answerView.setBackgroundImage(UIImage(named: "answerViewImageN"), // no
                                                for: .normal)
            }
        }
        didSelectAnswer?(sender.tag)
        stackView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) { [weak self] in
            guard let self else { return }
            answerView.setBackgroundImage(UIImage(named: "answerViewImage"), // gefault
                                            for: .normal)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0 ) { [weak self] in
            guard let self else { return }
            answerView.isUserInteractionEnabled = true
        }
    }
    private func setupeConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.left.equalTo(20)
            make.bottom.equalToSuperview()
        }
        answerView.snp.makeConstraints { make in
            make.height.equalTo(75)
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        answerView.titleLabel?.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalToSuperview().inset(15)
        }
    }
}
