//
//  JSONEncoder+TMDbTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

struct JSONEncoderTMDbTests {

    var jsonEncoder: JSONEncoder!

    /// 1990-01-02T00:00:00Z. An absolute instant rather than a
    /// formatter-derived one: deriving the expectation from a formatter makes
    /// both sides of the assertion move together, so the test would pass in any
    /// time zone whether or not the encoder pins one.
    private static let dateOfBirth = Date(timeIntervalSince1970: 631_238_400)

    init() {
        self.jsonEncoder = JSONEncoder.theMovieDatabase
    }

    @Test("encoder encodes object")
    func theMovieDatabaseEncoderEncodesObject() throws {
        let value = SomeThing(
            id: "abc123",
            firstName: "Adam",
            dateOfBirth: Self.dateOfBirth
        )

        let expectedIDResult = "\"id\":\"abc123\""
        let expectedFirstNameResult = "\"first_name\":\"Adam\""
        let expectedDataOfBirthResult = "\"date_of_birth\":\"1990-01-02\""

        let data = try jsonEncoder.encode(value)
        let dataAsString = try #require(String(data: data, encoding: .utf8))

        #expect(dataAsString.contains(expectedIDResult))
        #expect(dataAsString.contains(expectedFirstNameResult))
        #expect(dataAsString.contains(expectedDataOfBirthResult))
    }

}

extension JSONEncoderTMDbTests {

    private struct SomeThing: Encodable, Equatable {

        let id: String
        let firstName: String
        let dateOfBirth: Date

    }

}
