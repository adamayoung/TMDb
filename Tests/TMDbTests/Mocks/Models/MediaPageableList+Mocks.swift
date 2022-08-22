import Foundation
import TMDb

extension MediaPageableList {

    static func mock(
        page: Int = Int.random(in: 1...5),
        results: [Media] = .mocks,
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
