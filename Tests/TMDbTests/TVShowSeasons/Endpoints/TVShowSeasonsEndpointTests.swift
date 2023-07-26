@testable import TMDb
import XCTest

final class TVShowSeasonsEndpointTests: XCTestCase {

    func testTVShowSeasonDetailsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/season/2"))

        let url = TVShowSeasonsEndpoint.details(tvShowID: 1, seasonNumber: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSeasonImagesEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(
            string: "/tv/1/season/2/images?include_image_language=\(languageCode),null"
        ))

        let url = TVShowSeasonsEndpoint.images(tvShowID: 1, seasonNumber: 2, languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSeasonVideosEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(
            string: "/tv/1/season/2/videos?include_video_language=\(languageCode),null"
        ))

        let url = TVShowSeasonsEndpoint.videos(tvShowID: 1, seasonNumber: 2, languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

}
