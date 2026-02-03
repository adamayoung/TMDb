//
//  CollectionTranslationDataTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CollectionTranslationDataTests {

    @Test("JSON decoding with valid homepage URL", .tags(.decoding))
    func decodeWithValidHomepageURL() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CollectionTranslationData.self,
            fromResource: "collection-translation-data-with-homepage"
        )

        #expect(result.title == "Star Wars Filmreihe")
        #expect(result.overview.hasPrefix("\"Star Wars™\" ist die größte"))
        #expect(result.homepageURL == URL(string: "http://www.starwars-union.de"))
    }

    @Test("JSON decoding with empty homepage string returns nil", .tags(.decoding))
    func decodeWithEmptyHomepageReturnsNil() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CollectionTranslationData.self,
            fromResource: "collection-translation-data-empty-homepage"
        )

        #expect(result.title == "Star Wars gyűjtemény")
        #expect(result.homepageURL == nil)
    }

    @Test("JSON decoding with missing homepage returns nil", .tags(.decoding))
    func decodeWithMissingHomepageReturnsNil() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CollectionTranslationData.self,
            fromResource: "collection-translation-data-no-homepage"
        )

        #expect(result.title == "スター・ウォーズ シリーズ")
        #expect(result.homepageURL == nil)
    }

    @Test("init sets all properties correctly")
    func initSetsProperties() {
        let url = URL(string: "https://www.starwars.com")
        let data = CollectionTranslationData(
            title: "Star Wars",
            overview: "An epic saga",
            homepageURL: url
        )

        #expect(data.title == "Star Wars")
        #expect(data.overview == "An epic saga")
        #expect(data.homepageURL == url)
    }

    @Test("JSON encoding and decoding round trip", .tags(.encoding))
    func encodeAndDecodeRoundTrip() throws {
        let url = URL(string: "https://www.starwars.com")
        let original = CollectionTranslationData(
            title: "Star Wars",
            overview: "An epic saga",
            homepageURL: url
        )

        let data = try JSONEncoder.theMovieDatabase.encode(original)
        let decoded = try JSONDecoder.theMovieDatabase.decode(
            CollectionTranslationData.self,
            from: data
        )

        #expect(decoded.title == original.title)
        #expect(decoded.overview == original.overview)
        #expect(decoded.homepageURL == original.homepageURL)
    }

    @Test("JSON encoding with nil homepage", .tags(.encoding))
    func encodeWithNilHomepage() throws {
        let original = CollectionTranslationData(
            title: "Test Collection",
            overview: "Test overview",
            homepageURL: nil
        )

        let data = try JSONEncoder.theMovieDatabase.encode(original)
        let decoded = try JSONDecoder.theMovieDatabase.decode(
            CollectionTranslationData.self,
            from: data
        )

        #expect(decoded.title == original.title)
        #expect(decoded.overview == original.overview)
        #expect(decoded.homepageURL == nil)
    }

}
