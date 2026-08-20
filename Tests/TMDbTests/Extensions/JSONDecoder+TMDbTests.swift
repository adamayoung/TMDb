//
//  JSONDecoder+TMDbTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

struct JSONDecoderTMDbTests {

    var jsonDecoder: JSONDecoder!

    /// 1990-01-02T00:00:00Z. An absolute instant rather than a
    /// formatter-derived one: deriving the expectation from a formatter makes
    /// both sides of the assertion move together, so the test would pass in any
    /// time zone whether or not the decoder pins one.
    private static let dateOfBirth = Date(timeIntervalSince1970: 631_238_400)

    init() {
        self.jsonDecoder = JSONDecoder.theMovieDatabase
    }

    @Test("decodes object from JSON")
    func theMovieDatabaseDecoderDecodesObject() throws {
        let expectedResult = SomeThing(
            id: "abc123",
            firstName: "Adam",
            dateOfBirth: Self.dateOfBirth
        )

        let jsonString = """
        {
            "id": "abc123",
            "first_name": "Adam",
            "date_of_birth": "1990-01-02"
        }
        """
        let data = Data(jsonString.utf8)

        let result = try jsonDecoder.decode(SomeThing.self, from: data)

        #expect(result == expectedResult)
    }

}

extension JSONDecoderTMDbTests {

    private struct SomeThing: Decodable, Equatable {

        let id: String
        let firstName: String
        let dateOfBirth: Date

    }

}
