
import UIKit
import SnapKit

class InfoController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "closeView"), for: .normal)
        view.tag = 1
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private let infoViewImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "infoView")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
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
        view.addSubview(closeButton)
        view.addSubview(infoViewImage)
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
        infoViewImage.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(20)
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
