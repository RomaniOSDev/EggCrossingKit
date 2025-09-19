

import Foundation

enum UserDefaultsKeys {
    case firstInit
    case quizResult
    case puzzleResults
    
    var key: String {
        switch self {
        case .firstInit: return "EggCrossingFirstInitSave"
        case .quizResult: return "EggCrossingQuizResultSave"
        case .puzzleResults: return "EggCrossingPuzzleResultsSave"
        }
    }
}
