//
//  MovieListItem+Mocks.swift
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
@testable import TMDb

extension MovieListItem {

    static func mock(
        id: Int = Int.randomID,
        title: String = "Movie",
        originalTitle: String = "Movie a",
        originalLanguage: String = "en",
        overview: String = .randomString,
        genreIDs: [Genre.ID] = [Genre].mocks.map(\.id),
        releaseDate: Date? = .random,
        posterPath: URL? = .randomImagePath,
        backdropPath: URL? = .randomImagePath,
        popularity: Double? = Double.random(in: 1 ... 10),
        voteAverage: Double? = Double.random(in: 1 ... 10),
        voteCount: Int? = Int.random(in: 1 ... 1000),
        hasVideo: Bool? = .random(),
        isAdultOnly: Bool? = .random()
    ) -> Self {
        .init(
            id: id,
            title: title,
            originalTitle: originalTitle,
            originalLanguage: originalLanguage,
            overview: overview,
            genreIDs: genreIDs,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: popularity,
            voteAverage: voteAverage,
            voteCount: voteCount,
            hasVideo: hasVideo,
            isAdultOnly: isAdultOnly
        )
    }

    static var bulletTrain: Self {
        .mock(
            id: 718_930,
            title: "Bullet Train",
            overview: """
            Unlucky assassin Ladybug is determined to do his job peacefully after one too many gigs gone \
            off the rails. Fate, however, may have other plans, as Ladybug's latest mission puts him on a collision \
            course with lethal adversaries from around the globe—all with connected, yet conflicting, objectives—on \
            the world's fastest train.
            """,
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2022-07-03")
        )
    }

    static var thorLoveAndThunder: Self {
        .mock(
            id: 616_037,
            title: "Thor: Love and Thunder",
            overview: """
            After his retirement is interrupted by Gorr the God Butcher, a galactic killer who seeks the \
            extinction of the gods, Thor Odinson enlists the help of King Valkyrie, Korg, and ex-girlfriend Jane \
            Foster, who now inexplicably wields Mjolnir as the Relatively Mighty Girl Thor. Together they embark \
            upon a harrowing cosmic adventure to uncover the mystery of the God Butcher's vengeance and stop him \
            before it's too late.
            """,
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2022-07-06")
        )
    }

    static var jurassicWorldDominion: Self {
        .mock(
            id: 507_086,
            title: "Jurassic World Dominion",
            overview: """
            Four years after Isla Nublar was destroyed, dinosaurs now live—and hunt—alongside humans all \
            over the world. This fragile balance will reshape the future and determine, once and for all, whether \
            human beings are to remain the apex predators on a planet they now share with history's most fearsome \
            creatures.
            """,
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2022-06-01")
        )
    }

    static var topGunMaverick: Self {
        .mock(
            id: 361_743,
            title: "Top Gun: Maverick",
            overview: """
            After more than thirty years of service as one of the Navy's top aviators, and dodging the \
            advancement in rank that would ground him, Pete “Maverick” Mitchell finds himself training a detachment \
            of TOP GUN graduates for a specialized mission the likes of which no living pilot has ever seen.
            """,
            releaseDate: DateFormatter.theMovieDatabase.date(from: "2022-05-24")
        )
    }

    // swiftlint:disable line_length
    static var theFirstOmen: MovieListItem {
        MovieListItem(
            id: 437_342,
            title: "The First Omen",
            originalTitle: "The First Omen",
            originalLanguage: "en",
            overview: "When a young American woman is sent to Rome to begin a life of service to the church, she encounters a darkness that causes her to question her own faith and uncovers a terrifying conspiracy that hopes to bring about the birth of evil incarnate.",
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

extension [MovieListItem] {

    static var mocks: [Element] {
        [
            .bulletTrain,
            .thorLoveAndThunder,
            .jurassicWorldDominion,
            .topGunMaverick
        ]
    }

}
