//
//  DateFormatter+TMDbTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct DataFormatterTMDbTests {

    @Test("formatter has correct date format")
    func theMovieDatabaseFormatterHasCorrectDateFormat() {
        let expectedResult = "yyyy-MM-dd"

        let result = DateFormatter.theMovieDatabase.dateFormat

        #expect(result == expectedResult)
    }

    @Test("ISO 8601 formatter has correct date format")
    func theMovieDatabaseISO8601FormatterHasCorrectDateFormat() {
        let expectedResult = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        let result = DateFormatter.theMovieDatabaseISO8601.dateFormat

        #expect(result == expectedResult)
    }

    @Test("ISO 8601 formatter parses date correctly")
    func theMovieDatabaseISO8601FormatterParsesDateCorrectly() throws {
        let dateString = "2024-10-15T18:59:47.000Z"

        let date = try #require(DateFormatter.theMovieDatabaseISO8601.date(from: dateString))

        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 10
        dateComponents.day = 15
        dateComponents.hour = 18
        dateComponents.minute = 59
        dateComponents.second = 47
        dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
        let expectedDate = try #require(
            Calendar(identifier: .gregorian).date(from: dateComponents)
        )

        #expect(date == expectedDate)
    }

}
