//
//  MediaListSummaryTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MediaListSummaryTests {

    @Test("JSON decoding of MediaListSummary", .tags(.decoding))
    func decodeReturnsMediaListSummary() throws {
        let json = """
        {
            "id": 1,
            "name": "Test List",
            "description": "Test Description",
            "item_count": 10,
            "favorite_count": 5,
            "iso_639_1": "en",
            "iso_3166_1": "US",
            "list_type": "movie",
            "poster_path": "/poster.jpg"
        }
        """

        let data = try #require(json.data(using: .utf8))
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListSummary.self, from: data)

        #expect(result.id == 1)
        #expect(result.name == "Test List")
        #expect(result.description == "Test Description")
        #expect(result.itemCount == 10)
        #expect(result.favoriteCount == 5)
        #expect(result.iso6391 == "en")
        #expect(result.iso31661 == "US")
        #expect(result.listType == "movie")
        #expect(result.posterPath == URL(string: "/poster.jpg"))
    }

    @Test("JSON decoding of MediaListSummary with null values", .tags(.decoding))
    func decodeReturnsMediaListSummaryWithNullValues() throws {
        let json = """
        {
            "id": 2,
            "name": "List 2",
            "description": null,
            "item_count": 20,
            "favorite_count": 10,
            "iso_639_1": "en",
            "iso_3166_1": "US",
            "list_type": "movie",
            "poster_path": null
        }
        """

        let data = try #require(json.data(using: .utf8))
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListSummary.self, from: data)

        #expect(result.id == 2)
        #expect(result.name == "List 2")
        #expect(result.description == nil)
        #expect(result.itemCount == 20)
        #expect(result.favoriteCount == 10)
        #expect(result.posterPath == nil)
    }

    @Test("JSON decoding of MediaListSummary without list_type field", .tags(.decoding))
    func decodeReturnsMediaListSummaryWithoutListType() throws {
        let json = """
        {
            "id": 3,
            "name": "TV List",
            "description": "TV Series List",
            "item_count": 30,
            "favorite_count": 15,
            "iso_639_1": "en",
            "iso_3166_1": "US",
            "poster_path": "/tv_poster.jpg"
        }
        """

        let data = try #require(json.data(using: .utf8))
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListSummary.self, from: data)

        #expect(result.id == 3)
        #expect(result.name == "TV List")
        #expect(result.description == "TV Series List")
        #expect(result.itemCount == 30)
        #expect(result.favoriteCount == 15)
        #expect(result.iso6391 == "en")
        #expect(result.iso31661 == "US")
        #expect(result.listType == nil)
        #expect(result.posterPath == URL(string: "/tv_poster.jpg"))
    }

}
