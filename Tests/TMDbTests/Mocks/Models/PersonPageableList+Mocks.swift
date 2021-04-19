import Foundation
import TMDb

extension PersonPageableList {

    static var mock: Self {
        .init(
            page: Int.random(in: 1...5),
            results: Person.mocks,
            totalResults: Int.random(in: 1...100),
            totalPages: Int.random(in: 1...5)
        )
    }

}
