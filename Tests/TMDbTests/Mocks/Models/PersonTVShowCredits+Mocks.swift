import Foundation
import TMDb

extension PersonTVShowCredits {

    static func mock(
        id: Int = .randomID,
        cast: [TVShow] = .mocks,
        crew: [TVShow] = .mocks
    ) -> Self {
        .init(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
