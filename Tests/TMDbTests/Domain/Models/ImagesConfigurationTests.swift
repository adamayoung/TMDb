//
//  ImagesConfigurationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ImagesConfigurationTests {

    @Test("JSON decoding of ImageMetadata", .tags(.decoding))
    func decodeReturnsImagesConfiguration() throws {
        let imagesConfiguration = try ImagesConfiguration(
            baseURL: #require(URL(string: "http://image.tmdb.org/t/p/")),
            secureBaseURL: #require(URL(string: "https://image.tmdb.org/t/p/")),
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )

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

}
