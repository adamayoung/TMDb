import Foundation
import TMDb

extension Person {

    static var mock: Self {
        .init(
            id: .randomID,
            name: .randomString
        )
    }

    static var mocks: [Self] {
        (0...Int.random(in: 1...10)).map { _ in
            .mock
        }
    }

}
