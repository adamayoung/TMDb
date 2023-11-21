//
//  DiscoverIntegrationTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import TMDb
import XCTest

final class DiscoverIntegrationTests: XCTestCase {

    var discoverService: DiscoverService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        discoverService = DiscoverService()
    }

    override func tearDown() {
        discoverService = nil
        super.tearDown()
    }

    func testMovies() async throws {
        let movieList = try await discoverService.movies()

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testTVSeries() async throws {
        let tvSeriesList = try await discoverService.tvSeries()

        XCTAssertFalse(tvSeriesList.results.isEmpty)
    }

}
