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
            id: "64fb16fbdb4ed610343d72c3",
            name: "20th Anniversary Trailer",
            site: "YouTube",
            key: "dfeUzm6KF4g",
            type: .trailer,
            size: .s1080,
            official: true,
            publishedAt: Date(timeIntervalSince1970: 1_571_165_987)
        )

        return VideoCollection(
            id: 550,
            results: [video, video, video]
        )
    }

}
