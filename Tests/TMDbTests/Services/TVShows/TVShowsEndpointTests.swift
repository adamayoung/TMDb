@testable import TMDb
import XCTest

class TVShowsEndpointTests: XCTestCase {

    func testTVShowDetailsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/1")!

        let url = TVShowsEndpoint.details(tvShowID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowCreditsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/1/credits")!

        let url = TVShowsEndpoint.credits(tvShowID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowReviewsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/1/reviews")!

        let url = TVShowsEndpoint.reviews(tvShowID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowReviewsEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/tv/1/reviews?page=2")!

        let url = TVShowsEndpoint.reviews(tvShowID: 1, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowImagesEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/1/images")!

        let url = TVShowsEndpoint.images(tvShowID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowVideosEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/1/videos")!

        let url = TVShowsEndpoint.videos(tvShowID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowRecommendationsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/1/recommendations")!

        let url = TVShowsEndpoint.recommendations(tvShowID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowRecommendationsEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/tv/1/recommendations?page=2")!

        let url = TVShowsEndpoint.recommendations(tvShowID: 1, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSimilarEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/1/similar")!

        let url = TVShowsEndpoint.similar(tvShowID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSimilarEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/tv/1/similar?page=2")!

        let url = TVShowsEndpoint.similar(tvShowID: 1, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowPopularEndpoint_returnsURL() {
        let expectedURL = URL(string: "/tv/popular")!

        let url = TVShowsEndpoint.popular().url

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowPopularEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/tv/popular?page=1")!

        let url = TVShowsEndpoint.popular(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

}
