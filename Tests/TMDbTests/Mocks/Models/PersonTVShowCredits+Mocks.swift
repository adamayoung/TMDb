import Foundation
import TMDb

extension PersonTVShowCredits {

    static var mock: Self {
        .init(
            id: .randomID,
            cast: TVShow.mocks,
            crew: TVShow.mocks
        )
    }

}
