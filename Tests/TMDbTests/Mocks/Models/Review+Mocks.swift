//
//  Review+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension Review {

    static func mock(
        id: String = "1",
        author: String = "Author Name",
        content: String = "Some review content"
    ) -> Review {
        Review(
            id: id,
            author: author,
            content: content
        )
    }

}

extension [Review] {

    static var mocks: [Review] {
        [.mock(), .mock(), .mock()]
    }

}
