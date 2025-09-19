
import UIKit
import SnapKit

class SelectPuzzleView: UIViewController {
    
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
        view.setBackgroundImage(UIImage(named: "backButton"), for: .normal)
        view.tag = 1
        view.addTarget(self, action: #selector(tabButton), for: .touchUpInside)
        return view
    }()
    private let headerImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "headerPuzzleImage")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero,
                                   collectionViewLayout: layout)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.register(CollectionCell.self,
                      forCellWithReuseIdentifier: "puzzleSelectCell")
        view.register(PuzzleHeaderCell.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: "puzzleHeaderCell")
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
        view.addSubview(headerImageView)
        view.addSubview(closeButton)
        view.addSubview(collectionView)
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
        headerImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottomMargin.equalToSuperview()
        }
    }
}
extension SelectPuzzleView: UICollectionViewDelegateFlowLayout,
                              UICollectionViewDelegate,
                                UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        puzzleSection.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        puzzleSection[section].items.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "puzzleHeaderCell",
                                                                               for: indexPath) as? PuzzleHeaderCell else { return  UICollectionReusableView() }
            header.headerImage.image = puzzleSection[indexPath.section].headerImage
            return header
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "puzzleSelectCell",
                                                            for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        let data = puzzleSection[indexPath.section].items[indexPath.item]
        cell.configurePuzzleCell(data)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell {
            let data = puzzleSection[indexPath.section].items
            let type = puzzleSection[indexPath.section].items[indexPath.item]
            viewModel.viewAnimate(view: cell)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self else { return }
                openPuzzle(mode: type.mode,
                           data: data,
                           index: indexPath.item)
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
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width,
                      height: 55)
    }
}
extension SelectPuzzleView {
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
