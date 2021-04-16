import Foundation
import TMDb

extension Movie {

    static var mock: Self {
        let id = Int.randomID

        return .init(
            id: id,
            title: "Movie \(id)",
            overview: .randomString
        )
    }

    static var mocks: [Self] {
        (0...Int.random(in: 1...10)).map { _ in
            .mock
        }
    }

}
