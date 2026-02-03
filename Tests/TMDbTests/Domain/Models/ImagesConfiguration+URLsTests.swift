//
//  ImagesConfiguration+URLsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

// swiftlint:disable type_body_length
@Suite(.tags(.models))
struct ImagesConfigurationURLsTests {

    var configuration: ImagesConfiguration!
    var emptyConfiguration: ImagesConfiguration!

    init() throws {
        self.configuration = try ImagesConfiguration(
            baseURL: #require(URL(string: "http://image.tmdb.org/t/p/")),
            secureBaseURL: #require(URL(string: "https://image.tmdb.org/t/p/")),
            backdropSizes: ["w300", "w780", "w1280", "original"],
            logoSizes: ["w45", "w92", "w154", "w185", "w300", "w500", "original"],
            posterSizes: ["w92", "w154", "w185", "w342", "w500", "w780", "original"],
            profileSizes: ["w45", "w185", "h632", "original"],
            stillSizes: ["w92", "w185", "w300", "original"]
        )
        self.emptyConfiguration = try ImagesConfiguration(
            baseURL: #require(URL(string: "http://image.tmdb.org/t/p/")),
            secureBaseURL: #require(URL(string: "https://image.tmdb.org/t/p/")),
            backdropSizes: [],
            logoSizes: [],
            posterSizes: [],
            profileSizes: [],
            stillSizes: []
        )
    }

    @Test("backdropURL when path is nil returns nil")
    func backdropURLWhenPathIsNilReturnsNil() {
        let result = configuration.backdropURL(for: nil, idealWidth: 0)

        #expect(result == nil)
    }

    @Test("backdropURL when no ideal width is given returns originalURL")
    func backdropURLWhenNoWidthIsGivenReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = configuration.backdropURL(for: path)

        #expect(result == expectedResult)
    }

    @Test("backdropURL when width is very large returns originalURL")
    func backdropURLWhenWidthIsVeryLargeReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = configuration.backdropURL(for: path, idealWidth: 100_000)

        #expect(result == expectedResult)
    }

    @Test("backdropURL when width is 1280 returns w1280 URL")
    func backdropURLWhenWidth1280Returns1280URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w1280/image.jpg"))

        let result = configuration.backdropURL(for: path, idealWidth: 1280)

        #expect(result == expectedResult)
    }

    @Test("backdropURL when width is 900 returns w1280 URL")
    func backdropURLWhenWidth900Returns1280URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w1280/image.jpg"))

        let result = configuration.backdropURL(for: path, idealWidth: 900)

        #expect(result == expectedResult)
    }

    @Test("backdropURL when width is 200 returns w300 URL")
    func backdropURLWhenWidth200Returns300URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w300/image.jpg"))

        let result = configuration.backdropURL(for: path, idealWidth: 200)

        #expect(result == expectedResult)
    }

    @Test("backdropURL when configuration is empty returns originalURL")
    func backdropURLWhenConfigurationIsEmptyReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = emptyConfiguration.backdropURL(for: path)

        #expect(result == expectedResult)
    }

    @Test("logoURL when no width is given returns originalURL")
    func logoURLWhenNoWidthIsGivenReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = configuration.logoURL(for: path)

        #expect(result == expectedResult)
    }

    @Test("logoURL when width is very large returns originalURL")
    func logoURLWhenWidthIsVeryLargeReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = configuration.logoURL(for: path, idealWidth: 100_000)

        #expect(result == expectedResult)
    }

    @Test("logoURL when width is 500 returns w500 URL")
    func logoURLWhenWidth500Returns500URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w500/image.jpg"))

        let result = configuration.logoURL(for: path, idealWidth: 500)

        #expect(result == expectedResult)
    }

    @Test("logoURL when width is 400 returns w500 URL")
    func logoURLWhenWidth400Returns500URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w500/image.jpg"))

        let result = configuration.logoURL(for: path, idealWidth: 400)

        #expect(result == expectedResult)
    }

    @Test("logoURL when width is 40 returns w45 URL")
    func logoURLWhenWidth40Returns45URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w45/image.jpg"))

        let result = configuration.logoURL(for: path, idealWidth: 40)

        #expect(result == expectedResult)
    }

    @Test("logoURL when configuration is empty returns originalURL")
    func logoURLWhenConfigurationIsEmptyReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = emptyConfiguration.logoURL(for: path)

        #expect(result == expectedResult)
    }

    @Test("posterURL when no width is given returns originalURL")
    func posterURLWhenNoWidthIsGivenReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = configuration.posterURL(for: path)

        #expect(result == expectedResult)
    }

    @Test("posterURL when width is very large returns originalURL")
    func posterURLWhenWidthIsVeryLargeReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = configuration.posterURL(for: path, idealWidth: 100_000)

        #expect(result == expectedResult)
    }

    @Test("posterURL when width is 780 returns w780 URL")
    func posterURLWhenWidth780Returns780URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w780/image.jpg"))

        let result = configuration.posterURL(for: path, idealWidth: 780)

        #expect(result == expectedResult)
    }

    @Test("posterURL when width is 600 returns w780 URL")
    func posterURLWhenWidth600Returns780URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w780/image.jpg"))

        let result = configuration.posterURL(for: path, idealWidth: 600)

        #expect(result == expectedResult)
    }

    @Test("posteURL when width is 90 returns w92 URL")
    func posterURLWhenWidth90Returns92URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w92/image.jpg"))

        let result = configuration.posterURL(for: path, idealWidth: 90)

        #expect(result == expectedResult)
    }

    @Test("posterURL when configuration is empty returns originalURL")
    func posterURLWhenConfigurationIsEmptyReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = emptyConfiguration.posterURL(for: path)

        #expect(result == expectedResult)
    }

    @Test("profileURL when no width is given returns originalURL")
    func profileURLWhenNoWidthIsGivenReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = configuration.profileURL(for: path)

        #expect(result == expectedResult)
    }

    @Test("profileURL when width is very large returns originalURL")
    func profileURLWhenWidthIsVeryLargeReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = configuration.profileURL(for: path, idealWidth: 100_000)

        #expect(result == expectedResult)
    }

    @Test("profileURL when width is 185 returns w185 URL")
    func profileURLWhenWidth185Returns185URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w185/image.jpg"))

        let result = configuration.profileURL(for: path, idealWidth: 185)

        #expect(result == expectedResult)
    }

    @Test("profileURL when width is 100 returns w185 URL")
    func profileURLWhenWidth100Returns185URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w185/image.jpg"))

        let result = configuration.profileURL(for: path, idealWidth: 100)

        #expect(result == expectedResult)
    }

    @Test("profileURL when width is 40 returns w45 URL")
    func profileURLWhenWidth40Returns45URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w45/image.jpg"))

        let result = configuration.profileURL(for: path, idealWidth: 40)

        #expect(result == expectedResult)
    }

    @Test("profileURL when configuration is empty returns originalURL")
    func profileURLWhenConfigurationIsEmptyReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = emptyConfiguration.profileURL(for: path)

        #expect(result == expectedResult)
    }

    @Test("stillURL when no width is given returns originalURL")
    func stillURLWhenNoWidthIsGivenReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = configuration.stillURL(for: path)

        #expect(result == expectedResult)
    }

    @Test("stillURL when width is very large returns originalURL")
    func stillURLWhenWidthIsVeryLargeReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = configuration.stillURL(for: path, idealWidth: 100_000)

        #expect(result == expectedResult)
    }

    @Test("stillURL when width is 300 returns w300 URL")
    func stillURLWhenWidth300Returns300URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w300/image.jpg"))

        let result = configuration.stillURL(for: path, idealWidth: 300)

        #expect(result == expectedResult)
    }

    @Test("stillURL when width is 190 returns w300 URL")
    func stillURLWhenWidth190Returns300URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w300/image.jpg"))

        let result = configuration.stillURL(for: path, idealWidth: 190)

        #expect(result == expectedResult)
    }

    @Test("stillURL when width is 50 returns w92 URL")
    func stillURLWhenWidth50Returns92URL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(URL(string: "https://image.tmdb.org/t/p/w92/image.jpg"))

        let result = configuration.stillURL(for: path, idealWidth: 50)

        #expect(result == expectedResult)
    }

    @Test("stillURL when configuration is empty returns originalURL")
    func stillURLWhenConfigurationIsEmptyReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expectedResult = try #require(
            URL(string: "https://image.tmdb.org/t/p/original/image.jpg")
        )

        let result = emptyConfiguration.stillURL(for: path)

        #expect(result == expectedResult)
    }

}

// swiftlint:enable type_body_length
