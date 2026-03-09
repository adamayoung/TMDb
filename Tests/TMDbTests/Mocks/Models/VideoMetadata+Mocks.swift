//
//  VideoMetadata+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension VideoMetadata {

    static func mock(
        id: String = "1",
        name: String = "Video name",
        site: String = "YouTube",
        key: String = "abc123",
        type: VideoType = .trailer,
        size: VideoSize = .s1080,
        official: Bool = true,
        publishedAt: Date = Date(timeIntervalSince1970: 0)
    ) -> VideoMetadata {
        VideoMetadata(
            id: id,
            name: name,
            site: site,
            key: key,
            type: type,
            size: size,
            official: official,
            publishedAt: publishedAt
        )
    }

}

extension [VideoMetadata] {

    static var mocks: [Element] {
        [.mock(), .mock(), .mock()]
    }

}
