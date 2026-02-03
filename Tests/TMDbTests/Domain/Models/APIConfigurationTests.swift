//
//  APIConfigurationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct APIConfigurationTests {

    @Test("JSON decoding of APIConfiguration", .tags(.decoding))
    func decodeAPIConfiguration() throws {
        let apiConfiguration = try apiConfiguration()

        let result = try JSONDecoder.theMovieDatabase.decode(
            APIConfiguration.self, fromResource: "api-configuration"
        )

        #expect(result.images == apiConfiguration.images)
        #expect(result.changeKeys == apiConfiguration.changeKeys)
    }

    // swiftlint:disable:next function_body_length
    private func apiConfiguration() throws -> APIConfiguration {
        try APIConfiguration(
            images: ImagesConfiguration(
                baseURL: #require(URL(string: "http://image.tmdb.org/t/p/")),
                secureBaseURL: #require(URL(string: "https://image.tmdb.org/t/p/")),
                backdropSizes: ["w300", "w780", "w1280", "original"],
                logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
                posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
                profileSizes: ["w45", "w185", "h632", "original"],
                stillSizes: ["w92", "w185", "w300", "original"]
            ),
            changeKeys: [
                "adult",
                "air_date",
                "also_known_as",
                "alternative_titles",
                "biography",
                "birthday",
                "budget",
                "cast",
                "certifications",
                "character_names",
                "created_by",
                "crew",
                "deathday",
                "episode",
                "episode_number",
                "episode_run_time",
                "freebase_id",
                "freebase_mid",
                "general",
                "genres",
                "guest_stars",
                "homepage",
                "images",
                "imdb_id",
                "languages",
                "name",
                "network",
                "origin_country",
                "original_name",
                "original_title",
                "overview",
                "parts",
                "place_of_birth",
                "plot_keywords",
                "production_code",
                "production_companies",
                "production_countries",
                "releases",
                "revenue",
                "runtime",
                "season",
                "season_number",
                "season_regular",
                "spoken_languages",
                "status",
                "tagline",
                "title",
                "translations",
                "tvdb_id",
                "tvrage_id",
                "type",
                "video",
                "videos"
            ]
        )
    }

}
