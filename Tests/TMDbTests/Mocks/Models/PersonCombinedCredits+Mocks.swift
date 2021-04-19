import Foundation
import TMDb

extension PersonCombinedCredits {

    static var mock: Self {
        .init(
            id: .randomID,
            cast: [
                .movie(.mock),
                .tvShow(.mock),
                .movie(.mock),
                .tvShow(.mock),
                .tvShow(.mock)
            ],
            crew: [
                .movie(.mock),
                .tvShow(.mock),
                .movie(.mock)
            ]
        )
    }

}
