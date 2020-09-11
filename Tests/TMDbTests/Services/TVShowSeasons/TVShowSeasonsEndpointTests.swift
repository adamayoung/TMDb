@testable import TMDb
import XCTest

class TVShowSeaonsEndpointTests: XCTestCase {

    func testTVShowSeasonDetailsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/1/season/2")!

        let url = TVShowSeasonsEndpoint.details(tvShowID: 1, seasonNumber: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSeasonImagesEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/1/season/2/images")!

        let url = TVShowSeasonsEndpoint.images(tvShowID: 1, seasonNumber: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSeasonVideosEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/1/season/2/videos")!

        let url = TVShowSeasonsEndpoint.videos(tvShowID: 1, seasonNumber: 2).url

        XCTAssertEqual(url, expectedURL)
    }

}
