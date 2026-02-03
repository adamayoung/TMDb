//
//  MediaPageableListTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MediaPageableListTests {

    @Test("JSON decoding of MediaPageableList", .tags(.decoding))
    func decodeReturnsMediaPageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(MediaPageableList.self, fromResource: "media-pageable-list")

        #expect(result.page == list.page)
        #expect(result.results == list.results)
        #expect(result.totalResults == list.totalResults)
        #expect(result.totalPages == list.totalPages)
    }

    private let list = MediaPageableList(
        page: 1,
        results: [
            .movie(.theFirstOmen),
            .tvSeries(.bigBrother),
            .person(.bradPitt),
            .collection(.vinylAndTheVelvetUndergroundAndNico)
        ],
        totalResults: 4,
        totalPages: 1
    )

}
