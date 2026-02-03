//
//  VideoCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct VideoCollectionTests {

    @Test("JSON decoding of VideoCollection", .tags(.decoding))
    func decodeReturnsVideoCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            VideoCollection.self, fromResource: "video-collection"
        )

        #expect(result.id == videoCollection.id)
        #expect(result.results == videoCollection.results)
    }

    private let videoCollection = VideoCollection(
        id: 550,
        results: [
            VideoMetadata(
                id: "533ec654c3a36854480003eb",
                name: "Trailer 1",
                site: "YouTube",
                key: "SUXWAEX2jlg",
                type: .trailer,
                size: .s720
            )
        ]
    )

}
