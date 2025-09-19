
import UIKit

class SelectController: UIViewController {
    
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
                      forCellWithReuseIdentifier: "selectCell")
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.5) {
                NSLayoutConstraint.deactivate(self.collectionView.constraints)
                NSLayoutConstraint.activate([
                    self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
                ])
                self.view.layoutIfNeeded()
            }
        }
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
        view.addSubview(settingsButton)
    }
    private func addConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 1500),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            settingsButton.widthAnchor.constraint(equalToConstant: 50),
            settingsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func tabButton(_ sender: UIButton) {
        switch sender.tag {
            case 1:
            openSettings()
            case 2:
            break
        default:
            break
        }
    }
}
extension SelectController: UICollectionViewDelegateFlowLayout,
                                     UICollectionViewDelegate,
                                     UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        selectData.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectCell",
                                                            for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        let data = selectData[indexPath.item]
        cell.configureSelectCell(data)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell {
            let data = selectData[indexPath.item]
            switch data.access {
            case true:
                viewModel.viewAnimate(view: cell)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    guard let self else { return }
                    openView(data.type )
                }
            case false:
                cell.shakeView()
                cell.showEndHideInfoView()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if viewModel.isOldIphoneOrIpad() == true {
            let width = (collectionView.bounds.width - 10)
            return CGSize(width: width,
                          height: (collectionView.bounds.height - 10) / 4)
        } else {
            let width = (collectionView.bounds.width - 10)
            return CGSize(width: width,
                          height: (collectionView.bounds.height - 10) / 3.3)
        }
        
        
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
extension SelectController {
    func openSettings() {
        let controller = SettingsController()
        navigationController?.pushViewController(controller, animated: false)
    }
    func openView(_ type: SelectType) {
        switch type {
        case .fairyTales:
            let controller = FairyTalesViewController()
            navigationController?.pushViewController(controller, animated: false)
        case .puzzle:
            let controller = SelectPuzzleView()
            navigationController?.pushViewController(controller, animated: false)
        case .quiz:
            let controller = SelectQuizModeView()
            navigationController?.pushViewController(controller, animated: false)
        case .something:
            break
        }
    }
}
