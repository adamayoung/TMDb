import Foundation
import TMDb

extension TVShow {

    static var mock: Self {
        let id = Int.randomID

        return .init(
            id: id,
            name: "TV Show \(id)",
            overview: .randomString,
            firstAirDate: Date.random
        )
    }

    static var mocks: [Self] {
        (0...Int.random(in: 1...10)).map { _ in
            .mock
        }
    }

}
