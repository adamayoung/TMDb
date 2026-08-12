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
        #expect(result.droppedItemCount == 0)
    }

    @Test(
        "JSON decoding of a MediaList skips an item with an unmodelled media type",
        .tags(.decoding)
    )
    func decodeSkipsItemWithUnmodelledMediaType() throws {
        let json = """
        {
          "created_by": "Travis Bell",
          "favorite_count": 0,
          "id": 1,
          "iso_639_1": "en",
          "item_count": 2,
          "items": [
            {
              "id": 1,
              "title": "A Movie",
              "original_title": "A Movie",
              "original_language": "en",
              "overview": "An overview.",
              "media_type": "movie"
            },
            {
              "id": 2,
              "name": "A Future Thing",
              "media_type": "podcast"
            }
          ],
          "name": "Mixed",
          "poster_path": null
        }
        """

        let result = try JSONDecoder.theMovieDatabase.decode(
            MediaList.self, from: Data(json.utf8)
        )

        #expect(result.items.count == 1)
        #expect(result.items[0].id == 1)
        #expect(result.droppedItemCount == 1)
    }

    @Test("JSON decoding of a MediaList whose item is malformed throws", .tags(.decoding))
    func decodeThrowsWhenItemIsMalformed() {
        let json = """
        {
          "created_by": "Travis Bell",
          "favorite_count": 0,
          "id": 1,
          "iso_639_1": "en",
          "item_count": 1,
          "items": [
            {
              "id": "not-an-int",
              "title": "A Movie",
              "original_title": "A Movie",
              "original_language": "en",
              "overview": "An overview.",
              "media_type": "movie"
            }
          ],
          "name": "Broken",
          "poster_path": null
        }
        """

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder.theMovieDatabase.decode(MediaList.self, from: Data(json.utf8))
        }
    }

    /// `MediaList` gained hand-written `CodingKeys`, and `.convertFromSnakeCase`
    /// means a raw value spelled `iso_639_1` rather than `iso6391` would silently
    /// drop the property with no compile error. This round-trips every key to pin
    /// them.
    ///
    /// Item *dates* are deliberately excluded from the comparison: the encoder's
    /// `yyyy-MM-dd` formatter carries no explicit time zone while `MediaListItem`
    /// parses at GMT, so a dated round-trip would shift a day in any
    /// negative-offset region. That divergence is pre-existing and out of scope
    /// here.
    @Test("a decoded MediaList round-trips its every key", .tags(.encoding))
    func mediaListRoundTripsEveryKey() throws {
        let decoder = JSONDecoder.theMovieDatabase
        let original = try decoder.decode(MediaList.self, fromResource: "media-list")

        let encoded = try JSONEncoder.theMovieDatabase.encode(original)
        let result = try decoder.decode(MediaList.self, from: encoded)

        #expect(result.id == original.id)
        #expect(result.name == original.name)
        #expect(result.description == original.description)
        #expect(result.createdBy == original.createdBy)
        #expect(result.iso6391 == original.iso6391)
        #expect(result.itemCount == original.itemCount)
        #expect(result.favoriteCount == original.favoriteCount)
        #expect(result.posterPath == original.posterPath)
        #expect(result.page == original.page)
        #expect(result.totalPages == original.totalPages)
        #expect(result.totalResults == original.totalResults)
        #expect(result.items.map(\.id) == original.items.map(\.id))
        #expect(result.items.map(\.title) == original.items.map(\.title))

        // Guards against a snake_case raw value silently dropping a property.
        #expect(result.iso6391 == "en")
        #expect(result.favoriteCount == 0)
        #expect(result.createdBy == "Travis Bell")
        #expect(result.itemCount == 69)
    }

}
