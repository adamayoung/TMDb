//
//  CertificationsEndpointTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class CertificationsEndpointTests: XCTestCase {

    func testMovieEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/certification/movie/list"))

        let url = CertificationsEndpoint.movie.path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/certification/tv/list"))

        let url = CertificationsEndpoint.tvSeries.path

        XCTAssertEqual(url, expectedURL)
    }

}
