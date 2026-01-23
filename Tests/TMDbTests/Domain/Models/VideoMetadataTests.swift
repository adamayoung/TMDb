//
//  VideoMetadataTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct VideoMetadataTests {

    @Test("JSON decoding of VideoMetadata", .tags(.decoding))
    func decodeReturnsVideoCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            VideoMetadata.self, fromResource: "video-metadata"
        )

        #expect(result.id == videoMetadata.id)
        #expect(result.name == videoMetadata.name)
        #expect(result.site == videoMetadata.site)
        #expect(result.key == videoMetadata.key)
        #expect(result.type == videoMetadata.type)
        #expect(result.size == videoMetadata.size)
    }

    private let videoMetadata = VideoMetadata(
        id: "533ec654c3a36854480003eb",
        name: "Trailer 1",
        site: "YouTube",
        key: "SUXWAEX2jlg",
        type: .trailer,
        size: .s720
    )

}
