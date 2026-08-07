//
//  V4ListWriteResultTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct V4ListWriteResultTests {

    // MARK: - V4CreateListResult

    @Test("decodes a create-list result, whose id key is `id` not `list_id`")
    func decodesCreateResult() throws {
        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4CreateListResult.self, fromResource: "v4-create-list-result"
        )

        #expect(result.success)
        #expect(result.id == 8_678_999)
    }

    // MARK: - V4ClearListResult

    @Test("decodes a clear-list result including how many items went")
    func decodesClearResult() throws {
        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4ClearListResult.self, fromResource: "v4-clear-list-result"
        )

        #expect(result.success)
        #expect(result.id == 8_678_999)
        #expect(result.itemsDeleted == 2)
    }

    // MARK: - V4ListItemsResult

    @Test("decodes a per-item result for a movie and a TV series")
    func decodesItemsResult() throws {
        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4ListItemsResult.self, fromResource: "v4-list-items-result"
        )

        #expect(result.success)
        #expect(result.results.count == 2)
        let movie = try #require(result.results.first { $0.mediaType == .movie })
        let tvSeries = try #require(result.results.first { $0.mediaType == .tvSeries })
        #expect(movie.mediaID == 550)
        #expect(tvSeries.mediaID == 1399)
        #expect(result.allItemsSucceeded)
        #expect(result.failures.isEmpty)
    }

    @Test("a partial failure reports success overall but surfaces the failed item")
    func decodesPartialFailure() throws {
        // TMDb answers success: true for a request in which individual items
        // failed — removing an item that is not in the list reproduces it — so
        // the per-item results are the only reliable signal.
        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4ListItemsResult.self, fromResource: "v4-list-items-result-partial-failure"
        )

        #expect(result.success)
        #expect(result.allItemsSucceeded == false)
        #expect(result.failures.count == 1)
        let failure = try #require(result.failures.first)
        #expect(failure.mediaID == 550)
        #expect(failure.mediaType == .movie)
    }

    // MARK: - Input models

    @Test("a media item encodes to the media_type/media_id shape TMDb expects")
    func encodesMediaItem() throws {
        let item = V4ListMediaItem.movie(550)

        let data = try JSONEncoder.theMovieDatabaseV4.encode(item)
        let json = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(json["media_type"] as? String == "movie")
        #expect(json["media_id"] as? Int == 550)
        #expect(json["comment"] == nil)
    }

    @Test("a TV media item uses the tv media type")
    func encodesTVMediaItem() throws {
        let item = V4ListMediaItem.tvSeries(1399)

        let data = try JSONEncoder.theMovieDatabaseV4.encode(item)
        let json = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(json["media_type"] as? String == "tv")
        #expect(json["media_id"] as? Int == 1399)
    }

    @Test("an item comment carries the comment, unlike a media item")
    func encodesItemComment() throws {
        let item = V4ListItemComment.movie(550, comment: "Rewatch for the twist")

        let data = try JSONEncoder.theMovieDatabaseV4.encode(item)
        let json = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(json["media_type"] as? String == "movie")
        #expect(json["media_id"] as? Int == 550)
        #expect(json["comment"] as? String == "Rewatch for the twist")
    }

    // MARK: - V4ListSortBy

    @Test(
        "renders the value TMDb accepts",
        arguments: [
            (V4ListSortBy.originalOrder(), "original_order.asc"),
            (V4ListSortBy.originalOrder(descending: true), "original_order.desc"),
            (V4ListSortBy.voteAverage(), "vote_average.asc"),
            (V4ListSortBy.voteAverage(descending: true), "vote_average.desc"),
            (V4ListSortBy.primaryReleaseDate(), "primary_release_date.asc"),
            (V4ListSortBy.primaryReleaseDate(descending: true), "primary_release_date.desc"),
            (V4ListSortBy.releaseDate(), "release_date.asc"),
            (V4ListSortBy.releaseDate(descending: true), "release_date.desc"),
            (V4ListSortBy.title(), "title.asc"),
            (V4ListSortBy.title(descending: true), "title.desc")
        ]
    )
    func rendersSortBy(sortBy: V4ListSortBy, expected: String) {
        // These ten are the whole accepted set — each was set against the live
        // API and read back to confirm it stuck.
        #expect(sortBy.description == expected)
    }

    @Test("defaults to ascending, matching a newly created list")
    func defaultsToAscending() {
        #expect(V4ListSortBy.originalOrder().description == "original_order.asc")
    }

}
