import Foundation
import TMDb

extension PersonMovieCredits {

    static var mock: Self {
        .init(
            id: .randomID,
            cast: Movie.mocks,
            crew: Movie.mocks
        )
    }

}
