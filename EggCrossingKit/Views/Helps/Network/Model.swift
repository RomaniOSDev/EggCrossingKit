
import Foundation

struct ResnonseData: Codable {
    let quize: Quize
    let fairyTails: String
}
struct Quize: Codable {
    let easy, medium, hard: [Easy]

    enum CodingKeys: String, CodingKey {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}
struct Easy: Codable {
    let questions: String
    let answers: [String]
    let currentIndex: Int

    enum CodingKeys: String, CodingKey {
        case questions, answers
        case currentIndex = "current_index"
    }
}
