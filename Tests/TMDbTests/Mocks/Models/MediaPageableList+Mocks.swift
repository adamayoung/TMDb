import Foundation
import TMDb

extension MediaPageableList {

    static var mock: Self {
        .init(
            page: Int.random(in: 1...5),
            results: [
                .movie(.mock),
                .movie(.mock),
                .tvShow(.mock),
                .tvShow(.mock),
                .movie(.mock),
                .tvShow(.mock)
            ],
            totalResults: Int.random(in: 1...100),
            totalPages: Int.random(in: 1...5)
        )
    }

}
