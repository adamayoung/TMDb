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
        size: VideoSize = .s1080
    ) -> VideoMetadata {
        VideoMetadata(
            id: id,
            name: name,
            site: site,
            key: key,
            type: type,
            size: size
        )
    }

}

extension [VideoMetadata] {

    static var mocks: [Element] {
        [.mock(), .mock(), .mock()]
    }

}
