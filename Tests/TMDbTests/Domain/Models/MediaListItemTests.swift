//
//  MediaListItemTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

        #expect(result.id == 986056)
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

        #expect(result.id == 123456)
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

        #expect(result.id == 999999)
        #expect(result.mediaType == .tvSeries)
        #expect(result.title == "Test TV Show")
    }

}
