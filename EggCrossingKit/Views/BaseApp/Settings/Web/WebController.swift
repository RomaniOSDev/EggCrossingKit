
import UIKit
import SnapKit
import WebKit
import StoreKit

class WebController: UIViewController {
    
    var isPolicy = true
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let backToViewButton: UIButton = {
        let view = UIButton()
        view.tintColor = .black
        view.setBackgroundImage(UIImage(systemName: "arrow.left.circle"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    private func setupViews() {
        view.addSubview(webView)
        view.addSubview(backToViewButton)
        backToViewButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.left.equalTo(20)
            make.height.width.equalTo(30)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview()
        }
        backToViewButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        if isPolicy == false {
            backToViewButton.isHidden = true
        }
    }
    @objc private func closeButtonTap() {
        navigationController?.popViewController(animated: false)
    }
    func loadURL(_ url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
