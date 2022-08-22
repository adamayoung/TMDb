import Foundation
import TMDb

extension MoviePageableList {

    static func mock(
        page: Int = .random(in: 1...5),
        results: [Movie] = .mocks,
        totalResults: Int = .random(in: 1...100),
        totalPages: Int = .random(in: 1...5)
    ) -> Self {
        .init(
            page: page,
            results: results,
            totalResults: totalResults,
            totalPages: totalPages
        )
    }

}
