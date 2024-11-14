//
//  Movie+Mocks.swift
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

extension Movie {

    static func mock(
        id: Int = 1,
        title: String = "Movie name",
        tagline: String? = "Movie Tag Line",
        originalTitle: String? = nil,
        originalLanguage: String? = "en",
        overview: String? = "Movie Overview",
        runtime: Int? = 120,
        genres: [Genre]? = [.action, .drama],
        releaseDate: Date? = Date(iso8601: "2013-11-15T10:20:00Z"),
        posterPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!,
        backdropPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!,
        budget: Double? = 1_000_000,
        revenue: Double? = 5_000_000,
        homepageURL: URL? = URL(string: "https://www.movie.com")!,
        imdbID: String? = "12345",
        status: Status? = .released,
        productionCompanies: [ProductionCompany]? = .mocks,
        productionCountries: [ProductionCountry]? = .mocks,
        spokenLanguages: [SpokenLanguage]? = .mocks,
        popularity: Double? = 5,
        voteAverage: Double? = 6,
        voteCount: Int? = 120,
        hasVideo: Bool? = false,
        isAdultOnly: Bool? = false
    ) -> Self {
        .init(
            id: id,
            title: title,
            tagline: tagline,
            originalTitle: originalTitle,
            originalLanguage: originalLanguage,
            overview: overview,
            runtime: runtime,
            genres: genres,
            releaseDate: releaseDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            budget: budget,
            revenue: revenue,
            homepageURL: homepageURL,
            imdbID: imdbID,
            status: status,
            productionCompanies: productionCompanies,
            productionCountries: productionCountries,
            spokenLanguages: spokenLanguages,
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

}

extension [Movie] {

    static var mocks: [Element] {
        [
            .bulletTrain,
            .thorLoveAndThunder,
            .jurassicWorldDominion,
            .topGunMaverick
        ]
    }

}
