
import UIKit
import SnapKit

final class CollectionCell: UICollectionViewCell {
    
    let viewModel = BaseViewModel.shared

    private var conteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()
    private let previewImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    private var infoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.image = UIImage(named: "infoViewCell")
        return view
    }()
    let selectImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "SELECTIMAGE")
        view.clipsToBounds = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
        setupeConstraint()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureSettingsCell(_ data: SettingsData) {
        previewImage.image = data.preview
    }
    func configureSelectCell(_ data: SelectData) {
        previewImage.image = data.image
    }
    func configureSelectQuizCell(_ data: QuizMode) {
        previewImage.image = data.image
        previewImage.contentMode = .scaleToFill
    }
    func configurePuzzleCell(_ data: PuzzleData) {
        previewImage.image = data.preview
        previewImage.layer.cornerRadius = 10
        previewImage.clipsToBounds = true
        previewImage.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    func showEndHideInfoView() {
        UIView.animate(withDuration: 0.5) {
            self.infoView.alpha = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.5) {
                self.infoView.alpha = 0.0
            }
        }
    }
}
private extension CollectionCell {
    func initialization() {
        contentView.addSubview(conteinerView)
        conteinerView.addSubview(previewImage)
        conteinerView.addSubview(infoView)
        conteinerView.addSubview(selectImage)
        selectImage.isHidden = true
        infoView.alpha = 0.0
    }
    func setupeConstraint() {
        conteinerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        previewImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        infoView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(contentView.frame.width / 2)
            make.height.equalTo(45)
        }
        selectImage.snp.makeConstraints { make in
            make.height.width.equalTo(55)
            make.centerY.equalTo(previewImage.snp.top).offset(30)
            make.centerX.equalTo(previewImage.snp.left).inset(20)
        }
    }
}
