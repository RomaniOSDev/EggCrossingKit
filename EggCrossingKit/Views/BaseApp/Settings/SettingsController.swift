
import UIKit
import SnapKit
import StoreKit

class SettingsController: UIViewController {
    
    let viewModel = BaseViewModel.shared
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "backgroundImage")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private lazy var backToMenuButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "backToMenuImage"),
                                for: .normal)
        view.tag = 1
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private let logoImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "appLogoAll")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: .zero,
                                   collectionViewLayout: layout)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.register(CollectionCell.self,
                      forCellWithReuseIdentifier: "settingsCell")
        view.delegate = self
        view.dataSource = self
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
        view.addSubview(logoImage)
        
        view.addSubview(collectionView)
        
        view.addSubview(backToMenuButton)
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
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.height.equalTo(120)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(backToMenuButton.snp.top)
        }
        backToMenuButton.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.centerX.equalToSuperview()
            make.bottomMargin.equalToSuperview().inset(15)
        }
    }
}
extension SettingsController: UICollectionViewDelegateFlowLayout,
                                     UICollectionViewDelegate,
                                     UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        settingsData.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsCell",
                                                            for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        let data = settingsData[indexPath.item]
        cell.configureSettingsCell(data)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell {
            let data = settingsData[indexPath.item]
            viewModel.viewAnimate(view: cell)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self else { return }
                switch data.type {
                case .rate:
                    SKStoreReviewController.requestRateApplication()
                case .result:
                    openScore()
                case .privacy:
                    openWeb()
                case .info:
                    openInfo()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        return CGSize(width: width,
                      height: width)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 0,
                            bottom: 10,
                            right: 0)
    }
}
extension SettingsController {
    func openWeb() {
        let controller = WebController()
        controller.isPolicy = true
        controller.loadURL(DataInitialization_EG.privacy.value)
        navigationController?.pushViewController(controller, animated: false)
    }
    func openInfo() {
        let controller = InfoController()
        navigationController?.pushViewController(controller, animated: false)
    }
    func openScore() {
        let controller = ScoreController()
        navigationController?.pushViewController(controller, animated: false)
    }
}
