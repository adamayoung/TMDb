@testable import TMDb
import XCTest

final class TVShowEpisodesEndpointTests: XCTestCase {

    func testTVShowEpisodeDetailsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/season/2/episode/3"))

        let url = TVShowEpisodesEndpoint.details(tvShowID: 1, seasonNumber: 2, episodeNumber: 3).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowEpisodeImagesEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/season/2/episode/3/images"))

        let url = TVShowEpisodesEndpoint.images(tvShowID: 1, seasonNumber: 2, episodeNumber: 3).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSeasonVideosEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/season/2/episode/3/videos"))

        let url = TVShowEpisodesEndpoint.videos(tvShowID: 1, seasonNumber: 2, episodeNumber: 3).path

        XCTAssertEqual(url, expectedURL)
    }

}
