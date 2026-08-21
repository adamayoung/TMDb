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

        // An absolute instant, not `DateFormatter.theMovieDatabase.date(from:)`:
        // deriving the expectation from the formatter under test moves both
        // sides of the assertion together, so it would hold in any zone whether
        // or not the formatter pins one. 2025-04-30T00:00:00Z.
        #expect(result.date == Date(timeIntervalSince1970: 1_745_971_200))
    }

    @Test("theMovieDatabaseAuth decoder throws for invalid date string")
    func theMovieDatabaseAuthDecoderThrowsForInvalidDate() {
        let jsonString = """
        {
            "date": "not-a-date"
        }
        """
        let data = Data(jsonString.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder.theMovieDatabaseAuth.decode(DateWrapper.self, from: data)
        }
    }

}

private extension DataFormatterTMDbTests {

    private struct DateWrapper: Decodable {
        let date: Date
    }

}
