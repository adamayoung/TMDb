//
//  ChangeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ChangeTests {

    @Test("JSON decoding of ChangeCollection", .tags(.decoding))
    func decodeChangeCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ChangeCollection.self,
            fromResource: "change-collection"
        )

        #expect(result.changes.count == 2)

        let titleChange = try #require(result.changes.first { $0.key == "title" })
        #expect(titleChange.items.count == 1)

        let titleItem = try #require(titleChange.items.first)
        #expect(titleItem.id == "5f8b1234abc12345")
        #expect(titleItem.action == "updated")
        #expect(titleItem.languageCode == "en")
        #expect(titleItem.countryCode == "US")

        let castChange = try #require(result.changes.first { $0.key == "cast" })
        #expect(castChange.items.count == 1)

        let castItem = try #require(castChange.items.first)
        #expect(castItem.id == "5f8b5678def67890")
        #expect(castItem.action == "added")
    }

    @Test("JSON decoding of ChangedIDCollection", .tags(.decoding))
    func decodeChangedIDCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ChangedIDCollection.self,
            fromResource: "changed-id-collection"
        )

        #expect(result.results.count == 3)
        #expect(result.page == 1)
        #expect(result.totalPages == 10)
        #expect(result.totalResults == 100)

        let firstItem = try #require(result.results.first)
        #expect(firstItem.id == 550)
        #expect(firstItem.adult == false)

        let secondItem = result.results[1]
        #expect(secondItem.id == 551)
        #expect(secondItem.adult == true)

        let thirdItem = result.results[2]
        #expect(thirdItem.id == 552)
        #expect(thirdItem.adult == nil)
    }

    @Test("AnyCodable string encoding and decoding")
    func anyCodableString() throws {
        let original = AnyCodable("test")
        let encoded = try JSONEncoder.theMovieDatabase.encode(original)
        let decoded = try JSONDecoder.theMovieDatabase.decode(AnyCodable.self, from: encoded)

        #expect(decoded.value as? String == "test")
    }

    @Test("AnyCodable int encoding and decoding")
    func anyCodableInt() throws {
        let original = AnyCodable(42)
        let encoded = try JSONEncoder.theMovieDatabase.encode(original)
        let decoded = try JSONDecoder.theMovieDatabase.decode(AnyCodable.self, from: encoded)

        #expect(decoded.value as? Int == 42)
    }

    @Test("AnyCodable double encoding and decoding")
    func anyCodableDouble() throws {
        let original = AnyCodable(3.14)
        let encoded = try JSONEncoder.theMovieDatabase.encode(original)
        let decoded = try JSONDecoder.theMovieDatabase.decode(AnyCodable.self, from: encoded)

        #expect(decoded.value as? Double == 3.14)
    }

    @Test("AnyCodable bool encoding and decoding")
    func anyCodableBool() throws {
        let original = AnyCodable(true)
        let encoded = try JSONEncoder.theMovieDatabase.encode(original)
        let decoded = try JSONDecoder.theMovieDatabase.decode(AnyCodable.self, from: encoded)

        #expect(decoded.value as? Bool == true)
    }

    @Test("AnyCodable nil encoding and decoding")
    func anyCodableNil() throws {
        let original = AnyCodable(nil)
        let encoded = try JSONEncoder.theMovieDatabase.encode(original)
        let decoded = try JSONDecoder.theMovieDatabase.decode(AnyCodable.self, from: encoded)

        #expect(decoded.value == nil)
    }

}
