//
//  JSONDecoder+TMDbTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct JSONDecoderTMDbTests {

    var jsonDecoder: JSONDecoder!
    var dateFormatter: DateFormatter!

    init() {
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddd"
        self.jsonDecoder = JSONDecoder.theMovieDatabase
    }

    @Test("decodes object from JSON")
    func theMovieDatabaseDecoderDecodesObject() throws {
        let expectedResult = try SomeThing(
            id: "abc123",
            firstName: "Adam",
            dateOfBirth: #require(dateFormatter.date(from: "1990-01-02"))
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
