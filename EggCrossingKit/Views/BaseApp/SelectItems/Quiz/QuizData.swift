
import UIKit

enum QuizMode {
    case easy
    case medium
    case hard
    
    var image: UIImage? {
        switch self {
            case .easy: return UIImage(named: "easy")
            case .medium: return UIImage(named: "medium")
            case .hard: return UIImage(named: "hard")
        }
    }
    var name: String {
        switch self {
            case .easy: return "easy"
            case .medium: return "medium"
            case .hard: return "hard"
        }
    }
}

let quizModeData = [QuizMode.easy,
                    QuizMode.medium,
                    QuizMode.hard]
