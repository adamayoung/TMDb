//
//  V4ListTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct V4ListTests {

    @Test("decodes a mixed movie and TV list")
    func decodesMixedList() throws {
        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4List.self, fromResource: "v4-list"
        )

        #expect(result.id == 8_678_999)
        #expect(result.name == "My Watchlist")
        #expect(result.description == "Films and shows to catch up on")
        #expect(result.isPublic)
        #expect(result.languageCode == "en")
        #expect(result.countryCode == "US")
        #expect(result.sortBy == "original_order.asc")
        #expect(result.createdBy.username == "testuser")
    }

    @Test("keeps every item — a short page would mean a dropped decode")
    func decodesEveryItem() throws {
        // `FailableDecodable` skips an element it cannot model, silently. This
        // reconciles the decoded count against the count TMDb reports, so a
        // decoder regression fails here rather than returning a quietly short
        // page.
        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4List.self, fromResource: "v4-list"
        )

        #expect(result.items.count == 2)
        #expect(result.items.count == result.itemCount)
        #expect(result.items.count == result.totalResults)
    }

    @Test("decodes a movie item and a TV item into the right Show cases")
    func decodesBothMediaTypes() throws {
        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4List.self, fromResource: "v4-list"
        )

        let movie = try #require(result.items.first { $0.id == 550 })
        let tvSeries = try #require(result.items.first { $0.id == 1399 })

        guard case .movie(let movieItem) = movie.media else {
            Issue.record("expected item 550 to decode as a movie")
            return
        }
        guard case .tvSeries(let tvSeriesItem) = tvSeries.media else {
            Issue.record("expected item 1399 to decode as a TV series")
            return
        }

        #expect(movieItem.title == "Fight Club")
        #expect(tvSeriesItem.name == "Game of Thrones")
    }

    @Test("stitches the top-level comments dictionary onto the right items")
    func stitchesComments() throws {
        // TMDb sends comments separately, keyed "<media_type>:<id>" — the items
        // themselves carry no comment field.
        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4List.self, fromResource: "v4-list-with-comments"
        )

        let movie = try #require(result.items.first { $0.id == 550 })
        let tvSeries = try #require(result.items.first { $0.id == 1399 })

        #expect(movie.comment == "A movie comment")
        #expect(tvSeries.comment == "A TV comment")
    }

    @Test("a null comment decodes as no comment")
    func nullCommentIsNil() throws {
        let result = try JSONDecoder.theMovieDatabaseV4.decode(
            V4List.self, fromResource: "v4-list"
        )

        let tvSeries = try #require(result.items.first { $0.id == 1399 })

        #expect(tvSeries.comment == nil)
    }

    @Test("an item decoded on its own has no comment")
    func standaloneItemHasNoComment() throws {
        let json = Data(#"""
        {"id": 550, "media_type": "movie", "title": "Fight Club",
         "original_title": "Fight Club", "adult": false, "genre_ids": [18],
         "original_language": "en", "overview": "", "popularity": 1.0,
         "release_date": "1999-10-15", "video": false, "vote_average": 8.4,
         "vote_count": 1}
        """#.utf8)

        let result = try JSONDecoder.theMovieDatabaseV4.decode(V4ListItem.self, from: json)

        #expect(result.id == 550)
        #expect(result.comment == nil)
    }

    @Test("round trips through encode and decode, comments included")
    func roundTrips() throws {
        let original = try JSONDecoder.theMovieDatabaseV4.decode(
            V4List.self, fromResource: "v4-list-with-comments"
        )

        let encoded = try JSONEncoder.theMovieDatabaseV4.encode(original)
        let result = try JSONDecoder.theMovieDatabaseV4.decode(V4List.self, from: encoded)

        #expect(result == original)
    }

}
