import Foundation
import TMDb

extension PersonCombinedCredits {

    static func mock(
        id: Int = .randomID,
        cast: [Show] = [
            .movie(.jurassicWorldDominion),
            .tvShow(.theSandman),
            .movie(.topGunMaverick),
            .tvShow(.sheHulk),
            .tvShow(.strangerThings)
        ],
        crew: [Show] = [
            .movie(.bulletTrain),
            .tvShow(.theSandman),
            .movie(.thorLoveAndThunder)
        ]
    ) -> Self {
        .init(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
