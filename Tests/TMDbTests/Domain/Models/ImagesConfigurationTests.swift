//
//  ImagesConfigurationTests.swift
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
struct ImagesConfigurationTests {

    @Test("JSON decoding of ImageMetadata", .tags(.decoding))
    func decodeReturnsImagesConfiguration() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(ImagesConfiguration.self, fromResource: "images-configuration")

        #expect(result.baseURL == imagesConfiguration.baseURL)
        #expect(result.secureBaseURL == imagesConfiguration.secureBaseURL)
        #expect(result.backdropSizes == imagesConfiguration.backdropSizes)
        #expect(result.logoSizes == imagesConfiguration.logoSizes)
        #expect(result.posterSizes == imagesConfiguration.posterSizes)
        #expect(result.profileSizes == imagesConfiguration.profileSizes)
        #expect(result.stillSizes == imagesConfiguration.stillSizes)
    }

    private let imagesConfiguration = ImagesConfiguration(
        baseURL: URL(string: "http://image.tmdb.org/t/p/")!,
        secureBaseURL: URL(string: "https://image.tmdb.org/t/p/")!,
        backdropSizes: [
            "w300",
            "w780",
            "w1280",
            "original",
        ],
        logoSizes: [
            "w45",
            "w92",
            "w154",
            "w185",
            "w300",
            "w500",
            "original",
        ],
        posterSizes: [
            "w92",
            "w154",
            "w185",
            "w342",
            "w500",
            "w780",
            "original",
        ],
        profileSizes: [
            "w45",
            "w185",
            "h632",
            "original",
        ],
        stillSizes: [
            "w92",
            "w185",
            "w300",
            "original",
        ]
    )

}
