import Foundation
import TMDb

extension Review {

    static var mock: Self {
        .init(
            id: .randomID,
            author: "Author \(String.randomID)",
            content: .randomString
        )
    }

    static var mocks: [Self] {
        (0...Int.random(in: 1...10)).map { _ in
            .mock
        }
    }

}
