//
//  DateFormatter+TMDbTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

struct DataFormatterTMDbTests {

    @Test("theMovieDatabase decoder parses yyyy-MM-dd date strings")
    func theMovieDatabaseDecoderParsesDateString() throws {
        let jsonString = """
        {
            "date": "2025-04-30"
        }
        """
        let data = Data(jsonString.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(DateWrapper.self, from: data)

        let expected = try #require(DateFormatter.theMovieDatabase.date(from: "2025-04-30"))
        #expect(result.date == expected)
    }

}

private extension DataFormatterTMDbTests {

    private struct DateWrapper: Decodable {
        let date: Date
    }

}
