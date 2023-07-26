@testable import TMDb
import XCTest

final class TVShowsEndpointTests: XCTestCase {

    func testTVShowDetailsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1"))

        let url = TVShowsEndpoint.details(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowCreditsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/credits"))

        let url = TVShowsEndpoint.credits(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowReviewsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/reviews"))

        let url = TVShowsEndpoint.reviews(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowReviewsEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/reviews?page=2"))

        let url = TVShowsEndpoint.reviews(tvShowID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowImagesEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/images?include_image_language=\(languageCode),null"))

        let url = TVShowsEndpoint.images(tvShowID: 1, languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowVideosEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(
            string: "/tv/1/videos?include_video_language=\(languageCode),null"
        ))

        let url = TVShowsEndpoint.videos(tvShowID: 1, languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowRecommendationsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/recommendations"))

        let url = TVShowsEndpoint.recommendations(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowRecommendationsEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/recommendations?page=2"))

        let url = TVShowsEndpoint.recommendations(tvShowID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSimilarEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/similar"))

        let url = TVShowsEndpoint.similar(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSimilarEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/1/similar?page=2"))

        let url = TVShowsEndpoint.similar(tvShowID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowPopularEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/popular"))

        let url = TVShowsEndpoint.popular().path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowPopularEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/tv/popular?page=1"))

        let url = TVShowsEndpoint.popular(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

}
