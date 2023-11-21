//
//  TVSeasonsEndpointTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class TVSeasonsEndpointTests: XCTestCase {

    func testTVSeasonDetailsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/season/2"))

        let url = TVSeasonsEndpoint.details(tvSeriesID: 1, seasonNumber: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeasonImagesEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(
            string: "/tv/1/season/2/images?include_image_language=\(languageCode),null"
        ))

        let url = TVSeasonsEndpoint.images(tvSeriesID: 1, seasonNumber: 2, languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeasonVideosEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(
            string: "/tv/1/season/2/videos?include_video_language=\(languageCode),null"
        ))

        let url = TVSeasonsEndpoint.videos(tvSeriesID: 1, seasonNumber: 2, languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

}
