
import UIKit
import SnapKit

class SelectQuizModeView: UIViewController {
    
    let viewModel = BaseViewModel.shared
    private var selectIndexPath: IndexPath?
    
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
                      forCellWithReuseIdentifier: "selectQuizModeCell")
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
        selectIndexPath = IndexPath(row: 0, section: 0)
    }
    private func setupeSubview() {
        view.addSubview(backgroundImageView)
        view.addSubview(collectionView)
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
    private func addConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalToSuperview().inset(20)
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(15)
            make.width.equalTo(36)
            make.height.equalTo(28)
        }
    }
}
extension SelectQuizModeView: UICollectionViewDelegateFlowLayout,
                                     UICollectionViewDelegate,
                                     UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        quizModeData.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectQuizModeCell",
                                                            for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        let data = quizModeData[indexPath.item]
        cell.configureSelectQuizCell(data)
        if selectIndexPath == indexPath {
            cell.selectImage.isHidden = false
        } else {
            cell.selectImage.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell {
            let data = quizModeData[indexPath.item]
            viewModel.viewAnimate(view: cell)
            selectIndexPath = indexPath
            collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self else { return }
                openQuiz(data)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.isOldIphoneOrIpad() == true {
            let width = (collectionView.bounds.width - 100)
            return CGSize(width: width,
                          height: (collectionView.bounds.height) / 4)
        } else {
            let width = (collectionView.bounds.width - 100)
            return CGSize(width: width,
                          height: (collectionView.bounds.height) / 3.3)
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
extension SelectQuizModeView {
    func openQuiz(_ mode: QuizMode) {
        let controller = QuizGameController()
        controller.mode = mode
        navigationController?.pushViewController(controller, animated: false)
    }
}
