//
//  MediaListTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MediaListTests {

    @Test("JSON decoding of MediaList", .tags(.decoding))
    func decodeReturnsMediaList() throws {
        let json = """
        {
          "created_by": "Travis Bell",
          "description": "The idea behind this list is to collect the live action comic book movies.",
          "favorite_count": 0,
          "id": 1,
          "iso_639_1": "en",
          "item_count": 69,
          "items": [],
          "name": "The Marvel Universe",
          "page": 1,
          "poster_path": "/coJVIUEOToAEGViuhclM7pXC75R.jpg",
          "total_pages": 4,
          "total_results": 69
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaList.self, from: data)

        #expect(result.id == 1)
        #expect(result.name == "The Marvel Universe")
        #expect(result.description != nil)
        #expect(result.createdBy == "Travis Bell")
        #expect(result.iso6391 == "en")
        #expect(result.itemCount == 69)
        #expect(result.favoriteCount == 0)
        #expect(result.posterPath?.absoluteString == "/coJVIUEOToAEGViuhclM7pXC75R.jpg")
        #expect(result.items.isEmpty)
        #expect(result.page == 1)
        #expect(result.totalPages == 4)
        #expect(result.totalResults == 69)
    }

    /// A v3 list holds movies and TV series together, and TMDb gives a TV row
    /// `name`/`original_name`/`first_air_date` with none of the movie keys.
    /// `MediaList.items` decodes all-or-nothing, so before this was supported
    /// `lists.details(forList:)` threw outright on any list containing a TV
    /// series — which is most real lists.
    ///
    /// The `media-list.json` fixture had no consumer at all until now, which is
    /// why nothing caught it: the decode test above uses an empty `items` array.
    @Test("JSON decoding of a MediaList holding both a movie and a TV series", .tags(.decoding))
    func decodeReturnsMediaListWithMixedMediaTypes() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MediaList.self,
            fromResource: "media-list"
        )

        #expect(result.items.count == 3)

        let movie = try #require(result.items.first { $0.id == 986_056 })
        #expect(movie.mediaType == .movie)
        #expect(movie.title == "Thunderbolts*")

        let tvSeries = try #require(result.items.first { $0.id == 200_875 })
        #expect(tvSeries.mediaType == .tvSeries)
        #expect(tvSeries.title == "IT: Welcome to Derry")
        #expect(tvSeries.originalTitle == "IT: Welcome to Derry")
        #expect(tvSeries.releaseDate == Date(iso8601: "2025-10-26T00:00:00Z"))
    }

}
