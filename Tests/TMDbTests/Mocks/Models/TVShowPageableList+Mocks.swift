import Foundation
import TMDb

extension TVShowPageableList {

    static func mock(
        page: Int = Int.random(in: 1...5),
        results: [TVShow] = .mocks,
        totalResults: Int? = Int.random(in: 1...100),
        totalPages: Int? = Int.random(in: 1...5)
    ) -> Self {
        .init(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
