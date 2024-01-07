@testable import TMDb
import XCTest

final class TVSeriesEndpointTests: XCTestCase {

    func testTVSeriesDetailsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1"))

        let url = TVSeriesEndpoint.details(tvSeriesID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesCreditsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/credits"))

        let url = TVSeriesEndpoint.credits(tvSeriesID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesReviewsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/reviews"))

        let url = TVSeriesEndpoint.reviews(tvSeriesID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesReviewsEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/reviews?page=2"))

        let url = TVSeriesEndpoint.reviews(tvSeriesID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesImagesEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/images?include_image_language=\(languageCode),null"))

        let url = TVSeriesEndpoint.images(tvSeriesID: 1, languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesVideosEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(
            string: "/tv/1/videos?include_video_language=\(languageCode),null"
        ))

        let url = TVSeriesEndpoint.videos(tvSeriesID: 1, languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesRecommendationsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/recommendations"))

        let url = TVSeriesEndpoint.recommendations(tvSeriesID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesRecommendationsEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/recommendations?page=2"))

        let url = TVSeriesEndpoint.recommendations(tvSeriesID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesSimilarEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/similar"))

        let url = TVSeriesEndpoint.similar(tvSeriesID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesSimilarEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/similar?page=2"))

        let url = TVSeriesEndpoint.similar(tvSeriesID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesPopularEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/popular"))

        let url = TVSeriesEndpoint.popular().path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesPopularEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/popular?page=1"))

        let url = TVSeriesEndpoint.popular(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVSeriesWatchEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/watch/providers"))

        let url = TVSeriesEndpoint.watch(tvSeriesID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieExternalIDsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/external_ids"))

        let url = TVSeriesEndpoint.externalIDs(tvSeriesID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

}
