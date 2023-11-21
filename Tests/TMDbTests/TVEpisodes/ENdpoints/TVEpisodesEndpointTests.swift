@testable import TMDb
import XCTest

final class TVEpisodesEndpointTests: XCTestCase {

    func testTVEpisodeDetailsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/season/2/episode/3"))

        let url = TVEpisodesEndpoint.details(tvSeriesID: 1, seasonNumber: 2, episodeNumber: 3).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVEpisodeImagesEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(
            string: "/tv/1/season/2/episode/3/images?include_image_language=\(languageCode),null"
        ))

        let url = TVEpisodesEndpoint.images(
            tvSeriesID: 1,
            seasonNumber: 2,
            episodeNumber: 3,
            languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeasonVideosEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(
            string: "/tv/1/season/2/episode/3/videos?include_video_language=\(languageCode),null"
        ))

        let url = TVEpisodesEndpoint.videos(
            tvSeriesID: 1,
            seasonNumber: 2,
            episodeNumber: 3,
            languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

}
