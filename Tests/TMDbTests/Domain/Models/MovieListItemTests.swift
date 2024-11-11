//
//  MovieListItemTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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
struct MovieListItemTests {

    @Test("JSON decoding of MovieListItem", .tags(.decoding))
    func decodeReturnsMovieListItem() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieListItem.self, fromResource: "movie-list-item")

        #expect(result == movie)
    }

}

extension MovieListItemTests {

    // swiftlint:disable line_length
    private var movie: MovieListItem {
        .init(
            id: 437_342,
            title: "The First Omen",
            originalTitle: "The First Omen",
            originalLanguage: "en",
            overview:
                "When a young American woman is sent to Rome to begin a life of service to the church, she encounters a darkness that causes her to question her own faith and uncovers a terrifying conspiracy that hopes to bring about the birth of evil incarnate.",
            genreIDs: [27],
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2024-04-05"),
            posterPath: URL(string: "/uGyiewQnDHPuiHN9V4k2t9QBPnh.jpg"),
            backdropPath: URL(string: "/tkHQ7tnYYUEnqlrKuhufIsSVToU.jpg"),
            popularity: 1080.713,
            voteAverage: 6.768,
            voteCount: 455,
            hasVideo: false,
            isAdultOnly: false
        )
    }
    // swiftlint:enable line_length

}
