//
//  GenresEndpointTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class GenresEndpointTests: XCTestCase {

    func testMovieEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/genre/movie/list"))

        let url = GenresEndpoint.movie.path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/genre/tv/list"))

        let url = GenresEndpoint.tvSeries.path

        XCTAssertEqual(url, expectedURL)
    }

}
