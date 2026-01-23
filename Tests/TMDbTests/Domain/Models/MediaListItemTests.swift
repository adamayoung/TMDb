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

    @Test("JSON decoding of MediaListItem with TV show", .tags(.decoding))
    func decodeReturnsMediaListItemWithTVShow() throws {
        let json = """
        {
          "adult": false,
          "backdrop_path": "/test.jpg",
          "id": 999999,
          "title": "Test TV Show",
          "original_title": "Test TV Show",
          "overview": "A test TV show.",
          "poster_path": "/test-poster.jpg",
          "media_type": "tv",
          "original_language": "en",
          "genre_ids": [18],
          "popularity": 15.0,
          "release_date": "2024-01-15",
          "video": false,
          "vote_average": 8.5,
          "vote_count": 500
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        #expect(result.id == 999_999)
        #expect(result.mediaType == .tvSeries)
        #expect(result.title == "Test TV Show")
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
