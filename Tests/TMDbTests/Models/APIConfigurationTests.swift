//
//  APIConfigurationTests.swift
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

@testable import TMDb
import XCTest

final class APIConfigurationTests: XCTestCase {

    func testDecodeReturnsAPIConfiguration() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(APIConfiguration.self, fromResource: "api-configuration")

        XCTAssertEqual(result.images, apiConfiguration.images)
        XCTAssertEqual(result.changeKeys, apiConfiguration.changeKeys)
    }

    private let apiConfiguration = APIConfiguration(
        images: ImagesConfiguration(
            baseURL: URL(string: "http://image.tmdb.org/t/p/")!,
            secureBaseURL: URL(string: "https://image.tmdb.org/t/p/")!,
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
