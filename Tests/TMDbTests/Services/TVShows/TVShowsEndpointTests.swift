@testable import TMDb
import XCTest

final class TVShowsEndpointTests: XCTestCase {

    func testTVShowDetailsEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1")!

        let url = TVShowsEndpoint.details(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowCreditsEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/credits")!

        let url = TVShowsEndpoint.credits(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowReviewsEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/reviews")!

        let url = TVShowsEndpoint.reviews(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowReviewsEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/tv/1/reviews?page=2")!

        let url = TVShowsEndpoint.reviews(tvShowID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowImagesEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/images")!

        let url = TVShowsEndpoint.images(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowVideosEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/videos")!

        let url = TVShowsEndpoint.videos(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowRecommendationsEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/recommendations")!

        let url = TVShowsEndpoint.recommendations(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowRecommendationsEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/tv/1/recommendations?page=2")!

        let url = TVShowsEndpoint.recommendations(tvShowID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSimilarEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/1/similar")!

        let url = TVShowsEndpoint.similar(tvShowID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowSimilarEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/tv/1/similar?page=2")!

        let url = TVShowsEndpoint.similar(tvShowID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowPopularEndpointReturnsURL() {
        let expectedURL = URL(string: "/tv/popular")!

        let url = TVShowsEndpoint.popular().path

        XCTAssertEqual(url, expectedURL)
    }

    func testTVShowPopularEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/tv/popular?page=1")!

        let url = TVShowsEndpoint.popular(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

}
