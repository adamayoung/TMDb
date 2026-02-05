//
//  PersonTranslationDataTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct PersonTranslationDataTests {

    @Test("JSON decoding of PersonTranslationData", .tags(.decoding))
    func decodeReturnsPersonTranslationData() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            PersonTranslationData.self,
            fromResource: "person-translation-data"
        )

        #expect(
            result.biography
                == "Thomas Cruise Mapother IV est un acteur et producteur de cinéma américain."
        )
    }

    @Test("init sets biography correctly")
    func initSetsBiography() {
        let data = PersonTranslationData(
            biography: "An American actor and producer."
        )

        #expect(data.biography == "An American actor and producer.")
    }

    @Test("JSON encoding and decoding round trip", .tags(.encoding))
    func encodeAndDecodeRoundTrip() throws {
        let original = PersonTranslationData(
            biography: "An American actor and producer."
        )

        let data = try JSONEncoder.theMovieDatabase.encode(original)
        let decoded = try JSONDecoder.theMovieDatabase.decode(
            PersonTranslationData.self,
            from: data
        )

        #expect(decoded.biography == original.biography)
    }

}
