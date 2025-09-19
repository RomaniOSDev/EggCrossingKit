
import UIKit
import SnapKit

class FairyTalesViewController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    private var contentSize: CGSize {
        CGSize(width: view.frame.width,
               height: view.frame.height)
    }
    
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
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.contentSize = contentSize
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var titleView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(named: "brownColorCustom")
        view.numberOfLines = 0
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "backgroundCustom")
        setupeSubview()
        addConstraints()
        let allQuizData = viewModel.setResponseData()
        if let text = allQuizData?.fairyTails {
            let attributedText = setFairyTalesTitle(text)
            titleView.attributedText = attributedText
        }
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleView)
        view.addSubview(closeButton)
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
   private func setFairyTalesTitle(_ inputText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: inputText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.paragraphSpacing = 8
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16,
                                     weight: .medium),
            .paragraphStyle: paragraphStyle
        ]
        attributedString.addAttributes(regularAttributes,
                                       range: NSRange(location: 0,
                                                      length: inputText.utf16.count))
        // Header
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20,
                                     weight: .bold),
            .paragraphStyle: paragraphStyle
        ]
        // Moral
        let moralAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16,
                                     weight: .semibold),
            .paragraphStyle: paragraphStyle
        ]
        let titlePattern = "^\\d+\\..*$"
        guard let titleRegex = try? NSRegularExpression(pattern: titlePattern,
                                                        options: [.anchorsMatchLines]) else {
            return attributedString
        }
        let moralPattern = "^Moral:.*$"
        guard let moralRegex = try? NSRegularExpression(pattern: moralPattern,
                                                        options: [.anchorsMatchLines,
                                                                  .caseInsensitive]) else {
            return attributedString
        }
        let titleMatches = titleRegex.matches(in: inputText,
                                              options: [],
                                              range: NSRange(location: 0,
                                                             length: inputText.utf16.count))
        for match in titleMatches {
            attributedString.addAttributes(titleAttributes, range: match.range)
        }
        let moralMatches = moralRegex.matches(in: inputText,
                                              options: [],
                                              range: NSRange(location: 0,
                                                             length: inputText.utf16.count))
        for match in moralMatches {
            attributedString.addAttributes(moralAttributes,
                                           range: match.range)
        }
        return attributedString
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
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(40)
        }
    }
}
extension FairyTalesViewController {
    func nextView() {
        let controller = WelcomeController()
        navigationController?.pushViewController(controller, animated: false)
    }
}
