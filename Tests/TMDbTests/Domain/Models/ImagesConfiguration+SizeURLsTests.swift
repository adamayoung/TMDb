//
//  ImagesConfiguration+SizeURLsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ImagesConfigurationSizeURLsTests {

    var configuration: ImagesConfiguration

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
    }

    @Test("posterURL with supported width size returns sized URL")
    func posterURLWithSupportedWidthReturnsSizedURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expected = try #require(URL(string: "https://image.tmdb.org/t/p/w500/image.jpg"))

        let result = configuration.posterURL(for: path, size: .width(500))

        #expect(result == expected)
    }

    @Test("posterURL with original size returns original URL")
    func posterURLWithOriginalReturnsOriginalURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expected = try #require(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let result = configuration.posterURL(for: path, size: .original)

        #expect(result == expected)
    }

    @Test("posterURL with nil path returns nil")
    func posterURLWithNilPathReturnsNil() {
        let result = configuration.posterURL(for: nil, size: .width(500))

        #expect(result == nil)
    }

    @Test("posterURL with unsupported size returns nil")
    func posterURLWithUnsupportedSizeReturnsNil() throws {
        let path = try #require(URL(string: "/image.jpg"))

        let result = configuration.posterURL(for: path, size: .width(999))

        #expect(result == nil)
    }

    @Test("backdropURL with nil path returns nil")
    func backdropURLWithNilPathReturnsNil() {
        let result = configuration.backdropURL(for: nil, size: .width(1280))

        #expect(result == nil)
    }

    @Test("logoURL with nil path returns nil")
    func logoURLWithNilPathReturnsNil() {
        let result = configuration.logoURL(for: nil, size: .width(154))

        #expect(result == nil)
    }

    @Test("profileURL with nil path returns nil")
    func profileURLWithNilPathReturnsNil() {
        let result = configuration.profileURL(for: nil, size: .height(632))

        #expect(result == nil)
    }

    @Test("stillURL with nil path returns nil")
    func stillURLWithNilPathReturnsNil() {
        let result = configuration.stillURL(for: nil, size: .width(300))

        #expect(result == nil)
    }

    @Test("profileURL with supported height size returns sized URL")
    func profileURLWithSupportedHeightReturnsSizedURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expected = try #require(URL(string: "https://image.tmdb.org/t/p/h632/image.jpg"))

        let result = configuration.profileURL(for: path, size: .height(632))

        #expect(result == expected)
    }

    @Test("backdropURL with supported size returns sized URL")
    func backdropURLWithSupportedSizeReturnsSizedURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expected = try #require(URL(string: "https://image.tmdb.org/t/p/w1280/image.jpg"))

        let result = configuration.backdropURL(for: path, size: .width(1280))

        #expect(result == expected)
    }

    @Test("logoURL with supported size returns sized URL")
    func logoURLWithSupportedSizeReturnsSizedURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expected = try #require(URL(string: "https://image.tmdb.org/t/p/w154/image.jpg"))

        let result = configuration.logoURL(for: path, size: .width(154))

        #expect(result == expected)
    }

    @Test("stillURL with supported size returns sized URL")
    func stillURLWithSupportedSizeReturnsSizedURL() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expected = try #require(URL(string: "https://image.tmdb.org/t/p/w300/image.jpg"))

        let result = configuration.stillURL(for: path, size: .width(300))

        #expect(result == expected)
    }

    @Test("backdropURL with unsupported size returns nil")
    func backdropURLWithUnsupportedSizeReturnsNil() throws {
        let path = try #require(URL(string: "/image.jpg"))

        let result = configuration.backdropURL(for: path, size: .width(999))

        #expect(result == nil)
    }

    @Test("backdropURL with unsupported height size returns nil")
    func backdropURLWithUnsupportedHeightSizeReturnsNil() throws {
        let path = try #require(URL(string: "/image.jpg"))

        let result = configuration.backdropURL(for: path, size: .height(632))

        #expect(result == nil)
    }

    @Test("logoURL with unsupported size returns nil")
    func logoURLWithUnsupportedSizeReturnsNil() throws {
        let path = try #require(URL(string: "/image.jpg"))

        let result = configuration.logoURL(for: path, size: .width(999))

        #expect(result == nil)
    }

    @Test("profileURL with unsupported size returns nil")
    func profileURLWithUnsupportedSizeReturnsNil() throws {
        let path = try #require(URL(string: "/image.jpg"))

        let result = configuration.profileURL(for: path, size: .width(999))

        #expect(result == nil)
    }

    @Test("stillURL with unsupported size returns nil")
    func stillURLWithUnsupportedSizeReturnsNil() throws {
        let path = try #require(URL(string: "/image.jpg"))

        let result = configuration.stillURL(for: path, size: .width(999))

        #expect(result == nil)
    }

    @Test("posterURL with original size always supported even when not listed")
    func posterURLWithOriginalAlwaysSupported() throws {
        let path = try #require(URL(string: "/image.jpg"))
        let expected = try #require(URL(string: "https://image.tmdb.org/t/p/original/image.jpg"))

        let emptyConfiguration = try ImagesConfiguration(
            baseURL: #require(URL(string: "http://image.tmdb.org/t/p/")),
            secureBaseURL: #require(URL(string: "https://image.tmdb.org/t/p/")),
            backdropSizes: [],
            logoSizes: [],
            posterSizes: [],
            profileSizes: [],
            stillSizes: []
        )

        let result = emptyConfiguration.posterURL(for: path, size: .original)

        #expect(result == expected)
    }

}
