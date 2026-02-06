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
        content: String = "Some review content",
        languageCode: String? = nil,
        mediaID: Int? = nil,
        mediaTitle: String? = nil,
        mediaType: String? = nil,
        url: URL? = nil
    ) -> Review {
        Review(
            id: id,
            author: author,
            content: content,
            languageCode: languageCode,
            mediaID: mediaID,
            mediaTitle: mediaTitle,
            mediaType: mediaType,
            url: url
        )
    }

}

extension [Review] {

    static var mocks: [Review] {
        [.mock(), .mock(), .mock()]
    }

}
