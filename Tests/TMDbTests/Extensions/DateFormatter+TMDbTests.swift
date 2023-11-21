//
//  DateFormatter+TMDbTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class DataFormatterTMDbTests: XCTestCase {

    func testTheMovieDatabaseFormatterHasCorrectDateFormat() {
        let expectedResult = "yyyy-MM-dd"

        let result = DateFormatter.theMovieDatabase.dateFormat

        XCTAssertEqual(result, expectedResult)
    }

}
