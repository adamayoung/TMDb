import Foundation
import TMDb

extension Review {

    static func mock(
        id: String = .randomID,
        author: String? = nil,
        content: String = .randomString
    ) -> Self {
        .init(
            id: id,
            author: author ?? "Author \(String.randomID)",
            content: content
        )
    }

}

extension Array where Element == Review {

    static var mocks: [Element] {
        [.mock(), .mock(), .mock()]
    }

}
