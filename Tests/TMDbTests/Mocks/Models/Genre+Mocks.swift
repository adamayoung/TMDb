import Foundation
@testable import TMDb

extension Genre {

    static func mock(
        id: Int = .randomID,
        name: String = .randomString
    ) -> Self {
        .init(
            id: id,
            name: name
        )
    }

    static var action: Self {
        .mock(id: 1, name: "Action")
    }

    static var drama: Self {
        .mock(id: 1, name: "Drama")
    }

    static var sciFi: Self {
        .mock(id: 3, name: "Sci-Fi")
    }

}

extension Array where Element == Genre {

    static var mocks: [Element] {
        [.action, .drama, .sciFi]
    }

}
