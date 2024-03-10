//
//  File.swift
//  
//
//  Created by Adam Young on 10/03/2024.
//

@testable import TMDb
import XCTest

final class ShowTypeTests: XCTestCase {

    func testMovieRawValue() {
        XCTAssertEqual(ShowType.movie.rawValue, "movie")
    }

    func testTVSeriesRawValue() {
        XCTAssertEqual(ShowType.tvSeries.rawValue, "tv")
    }

}
