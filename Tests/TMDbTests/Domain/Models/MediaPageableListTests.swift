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

    @Test(
        "JSON decoding of a page containing an unknown media_type drops only that item",
        .tags(.decoding)
    )
    func decodeWhenPageContainsUnknownMediaTypeDropsUnknownItem() throws {
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "id": 1,
                    "title": "A Movie",
                    "original_title": "A Movie",
                    "original_language": "en",
                    "overview": "An overview.",
                    "genre_ids": [],
                    "media_type": "movie"
                },
                {
                    "id": 2,
                    "name": "A Future Thing",
                    "media_type": "future_media"
                },
                {
                    "id": 3,
                    "name": "A TV Series",
                    "original_name": "A TV Series",
                    "original_language": "en",
                    "overview": "An overview.",
                    "genre_ids": [],
                    "origin_country": [],
                    "media_type": "tv"
                }
            ],
            "total_results": 3,
            "total_pages": 1
        }
        """
        let data = Data(json.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(MediaPageableList.self, from: data)

        #expect(result.results.count == 2)
        #expect(result.results.contains { $0.id == 1 })
        #expect(result.results.contains { $0.id == 3 })
        #expect(!result.results.contains { $0.id == 2 })
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
