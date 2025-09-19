

import UIKit
import SnapKit

final class PuzzleHeaderCell: UICollectionReusableView {
    let headerImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImage)
        backgroundColor = .clear
        headerImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
//            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
