@testable import TMDb
import XCTest

final class TVShowSeasonsEndpointTests: XCTestCase {

    func testTVShowSeasonDetailsEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/season/2")!

        let url = TVShowSeasonsEndpoint.details(tvShowID: 1, seasonNumber: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSeasonImagesEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/season/2/images?include_image_language=en,null")!

        let url = TVShowSeasonsEndpoint.images(tvShowID: 1, seasonNumber: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSeasonVideosEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/season/2/videos?include_video_language=en,null")!

        let url = TVShowSeasonsEndpoint.videos(tvShowID: 1, seasonNumber: 2).path

        XCTAssertEqual(url, expectedURL)
    }

}
