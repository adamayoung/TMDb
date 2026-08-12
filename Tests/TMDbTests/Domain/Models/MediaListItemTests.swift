//
//  MediaListItemTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MediaListItemTests {

    @Test("JSON decoding of MediaListItem with valid date", .tags(.decoding))
    func decodeReturnsMediaListItemWithValidDate() throws {
        let json = """
        {
          "adult": false,
          "backdrop_path": "/jYCyTdPfgT01IOJWDnnetr9RDX6.jpg",
          "id": 986056,
          "title": "Thunderbolts*",
          "original_title": "Thunderbolts*",
          "overview": "After finding themselves ensnared in a death trap.",
          "poster_path": "/hqcexYHbiTBfDIdDWxrxPtVndBX.jpg",
          "media_type": "movie",
          "original_language": "en",
          "genre_ids": [28, 878, 12],
          "popularity": 20.2419,
          "release_date": "2025-04-30",
          "video": false,
          "vote_average": 7.3,
          "vote_count": 3092
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        #expect(result.id == 986_056)
        #expect(result.mediaType == .movie)
        #expect(result.title == "Thunderbolts*")
        #expect(result.originalTitle == "Thunderbolts*")
        #expect(result.overview == "After finding themselves ensnared in a death trap.")
        #expect(result.originalLanguage == "en")
        #expect(result.genreIDs == [28, 878, 12])
        #expect(result.releaseDate != nil)
        #expect(result.posterPath?.absoluteString == "/hqcexYHbiTBfDIdDWxrxPtVndBX.jpg")
        #expect(result.backdropPath?.absoluteString == "/jYCyTdPfgT01IOJWDnnetr9RDX6.jpg")
        #expect(result.popularity == 20.2419)
        #expect(result.voteAverage == 7.3)
        #expect(result.voteCount == 3092)
        #expect(result.hasVideo == false)
        #expect(result.isAdultOnly == false)
    }

    @Test("JSON decoding of MediaListItem with empty date string", .tags(.decoding))
    func decodeReturnsMediaListItemWithEmptyDateAsNil() throws {
        let json = """
        {
          "adult": false,
          "backdrop_path": null,
          "id": 123456,
          "title": "Test Movie",
          "original_title": "Test Movie Original",
          "overview": "A test movie with empty release date.",
          "poster_path": null,
          "media_type": "movie",
          "original_language": "en",
          "genre_ids": [],
          "popularity": 10.5,
          "release_date": "",
          "video": false,
          "vote_average": 5.5,
          "vote_count": 100
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        #expect(result.id == 123_456)
        #expect(result.title == "Test Movie")
        #expect(result.releaseDate == nil)
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

    /// The real shape of a TV row from `/list/{id}` — `name`, `original_name` and
    /// `first_air_date`, with **no** `title`, `original_title`, `release_date` or
    /// `video`. Taken from list 8679585. The previous version of this test gave a
    /// TV row a `title` and a `release_date`, which TMDb never sends, so it
    /// passed while `lists.details(forList:)` failed on every real mixed list.
    @Test("JSON decoding of MediaListItem with a TV series", .tags(.decoding))
    func decodeReturnsMediaListItemWithTVSeries() throws {
        let json = """
        {
          "adult": false,
          "backdrop_path": "/2fOKVDoc2O3eZmBZesWPuE5kgPN.jpg",
          "id": 200875,
          "name": "IT: Welcome to Derry",
          "original_name": "IT: Welcome to Derry",
          "overview": "In 1962, amid a spate of unexplained disappearances.",
          "poster_path": "/nyy3BITeIjviv6PFIXtqvc8i6xi.jpg",
          "media_type": "tv",
          "original_language": "en",
          "genre_ids": [18, 9648],
          "popularity": 39.2708,
          "first_air_date": "2025-10-26",
          "vote_average": 8.216,
          "vote_count": 1585,
          "origin_country": ["US"]
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        #expect(result.id == 200_875)
        #expect(result.mediaType == .tvSeries)
        #expect(result.title == "IT: Welcome to Derry")
        #expect(result.originalTitle == "IT: Welcome to Derry")
        // Pinned to an explicit GMT instant: this type parses day-precision dates
        // at GMT midnight, while TVSeriesListItem uses the decoder's
        // local-timezone strategy. A formatter-derived expectation here would
        // pass in UTC and drift everywhere else.
        #expect(result.releaseDate == Date(iso8601: "2025-10-26T00:00:00Z"))
        #expect(result.hasVideo == nil)
    }

    @Test("JSON decoding of MediaListItem prefers title when both keys present", .tags(.decoding))
    func decodeReturnsMediaListItemPreferringTitleOverName() throws {
        let json = """
        {
          "id": 1,
          "title": "Movie Title",
          "name": "Series Name",
          "original_title": "Original Movie Title",
          "original_name": "Original Series Name",
          "overview": "Both key pairs present.",
          "media_type": "movie",
          "original_language": "en"
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        #expect(result.title == "Movie Title")
        #expect(result.originalTitle == "Original Movie Title")
    }

    @Test("JSON decoding of MediaListItem with empty first_air_date", .tags(.decoding))
    func decodeReturnsMediaListItemWithEmptyFirstAirDateAsNil() throws {
        let json = """
        {
          "id": 2,
          "name": "Unaired Series",
          "original_name": "Unaired Series",
          "overview": "Not yet aired.",
          "media_type": "tv",
          "original_language": "en",
          "first_air_date": ""
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        #expect(result.releaseDate == nil)
    }

    @Test("JSON decoding of MediaListItem with an unmodelled media type throws", .tags(.decoding))
    func decodeMediaListItemWithUnmodelledMediaTypeThrows() {
        let json = """
        {
          "id": 3,
          "title": "A Podcast",
          "original_title": "A Podcast",
          "overview": "Not a movie or a TV series.",
          "media_type": "podcast",
          "original_language": "en"
        }
        """

        let data = Data(json.utf8)

        #expect(throws: UnknownMediaTypeError(rawValue: "podcast")) {
            _ = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)
        }
    }

    /// A TV row re-encodes through the `title`/`original_title` keys, matching
    /// `CollectionListItem`, which faces the same two-shape input. Asserting the
    /// emitted keys rather than a decoded round-trip keeps this independent of
    /// the machine's timezone: the encoder's `yyyy-MM-dd` formatter has no
    /// explicit time zone while this type parses at GMT, so a dated round-trip
    /// would shift a day in any negative-offset region.
    @Test("a decoded TV series MediaListItem encodes through the title keys", .tags(.encoding))
    func tvSeriesMediaListItemEncodesThroughTitleKeys() throws {
        let json = """
        {
          "id": 200875,
          "name": "IT: Welcome to Derry",
          "original_name": "IT: Welcome to Derry",
          "overview": "In 1962, amid a spate of unexplained disappearances.",
          "media_type": "tv",
          "original_language": "en",
          "first_air_date": "2025-10-26"
        }
        """

        let item = try JSONDecoder.theMovieDatabase.decode(
            MediaListItem.self, from: Data(json.utf8)
        )

        let encoded = try JSONEncoder.theMovieDatabase.encode(item)
        let object = try #require(
            JSONSerialization.jsonObject(with: encoded) as? [String: Any]
        )

        #expect(object["title"] as? String == "IT: Welcome to Derry")
        #expect(object["original_title"] as? String == "IT: Welcome to Derry")
        #expect(object["name"] == nil)
        #expect(object["original_name"] == nil)
        #expect(object["media_type"] as? String == "tv")
    }

    @Test("an undated MediaListItem round-trips exactly", .tags(.encoding))
    func undatedMediaListItemRoundTrips() throws {
        let json = """
        {
          "id": 200875,
          "name": "IT: Welcome to Derry",
          "original_name": "IT: Welcome to Derry",
          "overview": "In 1962, amid a spate of unexplained disappearances.",
          "media_type": "tv",
          "original_language": "en",
          "genre_ids": [18, 9648],
          "popularity": 39.2708,
          "vote_average": 8.216,
          "vote_count": 1585
        }
        """

        let decoder = JSONDecoder.theMovieDatabase
        let original = try decoder.decode(MediaListItem.self, from: Data(json.utf8))

        let encoded = try JSONEncoder.theMovieDatabase.encode(original)
        let result = try decoder.decode(MediaListItem.self, from: encoded)

        #expect(result == original)
    }

    @Test("JSON decoding of MediaListItem with missing release_date", .tags(.decoding))
    func decodeReturnsMediaListItemWithMissingDateAsNil() throws {
        let json = """
        {
          "adult": false,
          "backdrop_path": null,
          "id": 789012,
          "title": "No Date Movie",
          "original_title": "No Date Movie Original",
          "overview": "A movie without a release date field.",
          "poster_path": null,
          "media_type": "movie",
          "original_language": "en",
          "genre_ids": [28],
          "popularity": 5.0,
          "video": false,
          "vote_average": 6.0,
          "vote_count": 50
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        #expect(result.id == 789_012)
        #expect(result.releaseDate == nil)
    }

    @Test("JSON decoding of MediaListItem with missing genre_ids", .tags(.decoding))
    func decodeReturnsMediaListItemWithMissingGenreIDsAsEmpty() throws {
        let json = """
        {
          "id": 654321,
          "title": "No Genres Movie",
          "original_title": "No Genres Movie Original",
          "overview": "A movie without a genre_ids field.",
          "media_type": "movie",
          "original_language": "en"
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        #expect(result.id == 654_321)
        #expect(result.genreIDs == [])
    }

    @Test("init sets all properties correctly")
    func initSetsAllProperties() throws {
        let releaseDate = Date(iso8601: "2024-06-15T00:00:00Z")
        let posterPath = try #require(URL(string: "/poster.jpg"))
        let backdropPath = try #require(URL(string: "/backdrop.jpg"))

        let item = MediaListItem(
            id: 12345,
            mediaType: .movie,
            title: "Test Movie",
            originalTitle: "Test Movie Original",
            originalLanguage: "en",
            overview: "A test overview",
            genreIDs: [28, 12],
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: 100.5,
            voteAverage: 8.0,
            voteCount: 1000,
            hasVideo: true,
            isAdultOnly: false
        )

        #expect(item.id == 12345)
        #expect(item.mediaType == .movie)
        #expect(item.title == "Test Movie")
        #expect(item.originalTitle == "Test Movie Original")
        #expect(item.originalLanguage == "en")
        #expect(item.overview == "A test overview")
        #expect(item.genreIDs == [28, 12])
        #expect(item.releaseDate == releaseDate)
        #expect(item.posterPath == posterPath)
        #expect(item.backdropPath == backdropPath)
        #expect(item.popularity == 100.5)
        #expect(item.voteAverage == 8.0)
        #expect(item.voteCount == 1000)
        #expect(item.hasVideo == true)
        #expect(item.isAdultOnly == false)
    }

}
