import Foundation
import TMDb

extension ReviewPageableList {

    static var mock: Self {
        .init(
            page: Int.random(in: 1...5),
            results: Review.mocks,
            totalResults: Int.random(in: 1...100),
            totalPages: Int.random(in: 1...5)
        )
    }

}
