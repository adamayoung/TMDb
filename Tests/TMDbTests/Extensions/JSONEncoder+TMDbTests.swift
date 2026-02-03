//
//  JSONEncoder+TMDbTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct JSONEncoderTMDbTests {

    var jsonEncoder: JSONEncoder!
    var dateFormatter: DateFormatter!

    init() {
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddd"
        self.jsonEncoder = JSONEncoder.theMovieDatabase
    }

    @Test("encoder encodes object")
    func theMovieDatabaseEncoderEncodesObject() throws {
        let value = try SomeThing(
            id: "abc123",
            firstName: "Adam",
            dateOfBirth: #require(dateFormatter.date(from: "1990-01-02"))
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
