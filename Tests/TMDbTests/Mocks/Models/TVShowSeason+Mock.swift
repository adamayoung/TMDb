import Foundation
import TMDb

extension TVShowSeason {

    static var mock: Self {
        let seasonNumber = Int.random(in: 1...10)

        return .init(
            id: .randomID,
            name: "Season \(seasonNumber)",
            seasonNumber: seasonNumber
        )
    }

}
