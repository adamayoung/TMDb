import Foundation
import TMDb

extension TVShowPageableList {

    static var mock: Self {
        .init(
            page: Int.random(in: 1...5),
            results: TVShow.mocks,
            totalResults: Int.random(in: 1...100),
            totalPages: Int.random(in: 1...5)
        )
    }

}
