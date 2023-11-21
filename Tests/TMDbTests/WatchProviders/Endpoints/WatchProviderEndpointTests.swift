//
//  WatchProviderEndpointTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class WatchProviderEndpointTests: XCTestCase {

    func testRegionsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/watch/providers/regions"))

        let url = WatchProviderEndpoint.regions.path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieEndpointWhenGivenRegionCodeReturnsURL() throws {
        let regionCode = "GB"
        let expectedURL = try XCTUnwrap(URL(string: "/watch/providers/movie?watch_region=\(regionCode)"))

        let url = WatchProviderEndpoint.movie(regionCode: regionCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieEndpointWhenNotGivenRegionCodeReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/watch/providers/movie"))

        let url = WatchProviderEndpoint.movie(regionCode: nil).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesWhenGivenRegionCodeEndpointReturnsURL() throws {
        let regionCode = "GB"
        let expectedURL = try XCTUnwrap(URL(string: "/watch/providers/tv?watch_region=\(regionCode)"))

        let url = WatchProviderEndpoint.tvSeries(regionCode: regionCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesWhenNotGivenRegionCodeEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/watch/providers/tv"))

        let url = WatchProviderEndpoint.tvSeries(regionCode: nil).path

        XCTAssertEqual(url, expectedURL)
    }

}
