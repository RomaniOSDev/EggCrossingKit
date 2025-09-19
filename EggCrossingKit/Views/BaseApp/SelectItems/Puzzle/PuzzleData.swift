
import UIKit

enum PuzzleMode {
    case yeasy
    case hard
}

struct PuzzleSection {
    let headerImage: UIImage?
    let items: [PuzzleData]
}

struct PuzzleData {
    let preview: UIImage?
    let index: Int?
    let puzzleElements: [String]
    let mode: PuzzleMode
}

let puzzleSection: [PuzzleSection] = [.init(headerImage: UIImage(named: "yeasyMode"),
                                            items: [.init(preview: UIImage(named: "puzzle1"),
                                                          index: 0,
                                                          puzzleElements: ["puzzle1_1", "puzzle1_2", "puzzle1_3", "puzzle1_4"],
                                                            mode: .yeasy),
                                                       .init(preview: UIImage(named: "puzzle2"),
                                                             index: 1,
                                                             puzzleElements: ["puzzle2_1", "puzzle2_2", "puzzle2_3", "puzzle2_4"],
                                                             mode: .yeasy),
                                                       .init(preview: UIImage(named: "puzzle3"),
                                                             index: 2,
                                                             puzzleElements: ["puzzle3_1", "puzzle3_2", "puzzle3_3", "puzzle3_4"],
                                                             mode: .yeasy),
                                                       .init(preview: UIImage(named: "puzzle4"),
                                                             index: 3,
                                                             puzzleElements: ["puzzle4_1", "puzzle4_2", "puzzle4_3", "puzzle4_4"],
                                                             mode: .yeasy),
                                                       .init(preview: UIImage(named: "puzzle5"),
                                                             index: 4,
                                                             puzzleElements: ["puzzle5_1", "puzzle5_2", "puzzle5_3", "puzzle5_4"],
                                                             mode: .yeasy),
                                                       .init(preview: UIImage(named: "puzzle6"),
                                                             index: 5,
                                                             puzzleElements: ["puzzle6_1", "puzzle6_2", "puzzle6_3", "puzzle6_4"],
                                                             mode: .yeasy),
                                                       .init(preview: UIImage(named: "puzzle7"),
                                                             index: 6,
                                                             puzzleElements: ["puzzle7_1", "puzzle7_2", "puzzle7_3", "puzzle7_4"],
                                                             mode: .yeasy),
                                                       .init(preview: UIImage(named: "puzzle8"),
                                                             index: 7,
                                                             puzzleElements: ["puzzle8_1", "puzzle8_2", "puzzle8_3", "puzzle8_4"],
                                                             mode: .yeasy)]),
                                          .init(headerImage: UIImage(named: "hadrMode"),
                                                items: [.init(preview: UIImage(named: "puzzle9"),
                                                              index: 0,
                                                              puzzleElements: ["puzzle_H1_1", "puzzle_H1_2", "puzzle_H1_3", "puzzle_H1_4", "puzzle_H1_5", "puzzle_H1_6", "puzzle_H1_7", "puzzle_H1_8"],
                                                              mode: .hard),
                                                        .init(preview: UIImage(named: "puzzle10"),
                                                              index: 1,
                                                              puzzleElements: ["puzzle_H2_1", "puzzle_H2_2", "puzzle_H2_3", "puzzle_H2_4", "puzzle_H2_5", "puzzle_H2_6", "puzzle_H2_7", "puzzle_H2_8"],
                                                              mode: .hard),
                                                        .init(preview: UIImage(named: "puzzle11"),
                                                              index: 2,
                                                              puzzleElements: ["puzzle_H3_1", "puzzle_H3_2", "puzzle_H3_3", "puzzle_H3_4", "puzzle_H3_5", "puzzle_H3_6", "puzzle_H3_7", "puzzle_H3_8"],
                                                              mode: .hard),
                                                        .init(preview: UIImage(named: "puzzle12"),
                                                              index: 3,
                                                              puzzleElements: ["puzzle_H4_1", "puzzle_H4_2", "puzzle_H4_3", "puzzle_H4_4", "puzzle_H4_5", "puzzle_H4_6", "puzzle_H4_7", "puzzle_H4_8"],
                                                              mode: .hard),
                                                        .init(preview: UIImage(named: "puzzle13"),
                                                              index: 4,
                                                              puzzleElements: ["puzzle_H5_1", "puzzle_H5_2", "puzzle_H5_3", "puzzle_H5_4", "puzzle_H5_5", "puzzle_H5_6", "puzzle_H5_7", "puzzle_H5_8"],
                                                              mode: .hard),
                                                        .init(preview: UIImage(named: "puzzle14"),
                                                              index: 5,
                                                              puzzleElements: ["puzzle_H6_1", "puzzle_H6_2", "puzzle_H6_3", "puzzle_H6_4", "puzzle_H6_5", "puzzle_H6_6", "puzzle_H6_7", "puzzle_H6_8"],
                                                              mode: .hard),
                                                        .init(preview: UIImage(named: "puzzle15"),
                                                              index: 6,
                                                              puzzleElements: ["puzzle_H7_1", "puzzle_H7_2", "puzzle_H7_3", "puzzle_H7_4", "puzzle_H7_5", "puzzle_H7_6", "puzzle_H7_7", "puzzle_H7_8"],
                                                              mode: .hard),
                                                        .init(preview: UIImage(named: "puzzle16"),
                                                              index: 7,
                                                              puzzleElements: ["puzzle_H8_1", "puzzle_H8_2", "puzzle_H8_3", "puzzle_H8_4", "puzzle_H8_5", "puzzle_H8_6", "puzzle_H8_7", "puzzle_H8_8"],
                                                              mode: .hard)])]

let yeasyCountPuzzle = puzzleSection.first?.items.count ?? 0 - 1
let hardCountPuzzle = puzzleSection.last?.items.count ?? 0 - 1
