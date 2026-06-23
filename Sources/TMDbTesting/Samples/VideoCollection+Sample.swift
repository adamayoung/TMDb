//
//  VideoCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension VideoCollection {

    /// A sample `VideoCollection` for use in tests and previews.
    static var sample: VideoCollection {
        let video = VideoMetadata(
            id: "1",
            name: "Video name",
            site: "YouTube",
            key: "abc123",
            type: .trailer,
            size: .s1080,
            official: true,
            publishedAt: Date(timeIntervalSince1970: 0)
        )

        return VideoCollection(
            id: 1,
            results: [video, video, video]
        )
    }

}
