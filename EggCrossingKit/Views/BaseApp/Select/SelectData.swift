
import UIKit

enum SelectType {
    case fairyTales
    case puzzle
    case quiz
    case something
}

struct SelectData {
    let type: SelectType
    let image: UIImage?
    let access: Bool
}


let selectData: [SelectData] = [.init(type: .puzzle,
                                      image: UIImage(named: "select2"),
                                      access: true),
                                .init(type: .quiz,
                                      image: UIImage(named: "select3"),
                                      access: true),
                                .init(type: .fairyTales,
                                      image: UIImage(named: "select1"),
                                      access: true)]
//                                .init(type: .something,
//                                      image: UIImage(named: "select4"),
//                                      access: false)]
