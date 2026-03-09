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
        authorDetails: ReviewAuthorDetails? = nil,
        url: URL? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) -> Review {
        Review(
            id: id,
            author: author,
            content: content,
            languageCode: languageCode,
            mediaID: mediaID,
            mediaTitle: mediaTitle,
            mediaType: mediaType,
            authorDetails: authorDetails,
            url: url,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}

extension [Review] {

    static var mocks: [Review] {
        [.mock(), .mock(), .mock()]
    }

}
