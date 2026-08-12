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
        #expect(result.droppedItemCount == 1)
    }

    /// The other half of the policy. A page used to swallow an element that
    /// failed for *any* reason, so a decoder regression arrived as a quietly
    /// short page with no signal at all.
    @Test(
        "JSON decoding of a page whose item fails for any other reason throws",
        .tags(.decoding)
    )
    func decodeWhenPageItemIsMalformedThrows() {
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "id": "not-an-int",
                    "title": "A Movie",
                    "original_title": "A Movie",
                    "original_language": "en",
                    "overview": "An overview.",
                    "media_type": "movie"
                }
            ],
            "total_results": 1,
            "total_pages": 1
        }
        """
        let data = Data(json.utf8)

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(MediaPageableList.self, from: data)
        }
    }

    @Test("a page built in code reports no dropped items")
    func pageBuiltInCodeReportsNoDroppedItems() {
        #expect(list.droppedItemCount == 0)
    }

    @Test("the dropped item count is not encoded", .tags(.encoding))
    func droppedItemCountIsNotEncoded() throws {
        let json = """
        {
            "page": 1,
            "results": [{"id": 2, "name": "A Future Thing", "media_type": "future_media"}],
            "total_results": 1,
            "total_pages": 1
        }
        """

        let decoded = try JSONDecoder.theMovieDatabase.decode(
            MediaPageableList.self, from: Data(json.utf8)
        )
        #expect(decoded.droppedItemCount == 1)

        let encoded = try JSONEncoder.theMovieDatabase.encode(decoded)
        let object = try #require(
            JSONSerialization.jsonObject(with: encoded) as? [String: Any]
        )

        #expect(object["dropped_item_count"] == nil)
        #expect(object["droppedItemCount"] == nil)
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
