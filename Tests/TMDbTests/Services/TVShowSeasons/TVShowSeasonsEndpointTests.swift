@testable import TMDb
import XCTest

final class TVShowSeaonsEndpointTests: XCTestCase {

    func testTVShowSeasonDetailsEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/season/2")!

        let url = TVShowSeasonsEndpoint.details(tvShowID: 1, seasonNumber: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSeasonImagesEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/season/2/images")!

        let url = TVShowSeasonsEndpoint.images(tvShowID: 1, seasonNumber: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSeasonVideosEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/season/2/videos")!

        let url = TVShowSeasonsEndpoint.videos(tvShowID: 1, seasonNumber: 2).url

        XCTAssertEqual(url, expectedURL)
    }

}
