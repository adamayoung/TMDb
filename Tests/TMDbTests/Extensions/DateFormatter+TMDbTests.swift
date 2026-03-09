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

}
