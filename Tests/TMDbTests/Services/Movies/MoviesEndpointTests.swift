@testable import TMDb
import XCTest

class MoviesEndpointTests: XCTestCase {

    func testMovieDetailsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/movie/1")!

        let url = MoviesEndpoint.details(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieCreditsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/movie/1/credits")!

        let url = MoviesEndpoint.credits(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieReviewsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/movie/1/reviews")!

        let url = MoviesEndpoint.reviews(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieReviewsEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/movie/1/reviews?page=2")!

        let url = MoviesEndpoint.reviews(movieID: 1, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieImagesEndpoint_returnsURL() {
        let expectedURL = URL(string: "/movie/1/images")!

        let url = MoviesEndpoint.images(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieVideosEndpoint_returnsURL() {
        let expectedURL = URL(string: "/movie/1/videos")!

        let url = MoviesEndpoint.videos(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieRecommendationsEndpoint_returnsURL() {
        let expectedURL = URL(string: "/movie/1/recommendations")!

        let url = MoviesEndpoint.recommendations(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieRecommendationsEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/movie/1/recommendations?page=2")!

        let url = MoviesEndpoint.recommendations(movieID: 1, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieSimilarEndpoint_returnsURL() {
        let expectedURL = URL(string: "/movie/1/similar")!

        let url = MoviesEndpoint.similar(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieSimilarEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/movie/1/similar?page=2")!

        let url = MoviesEndpoint.similar(movieID: 1, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviePopularEndpoint_returnsURL() {
        let expectedURL = URL(string: "/movie/popular")!

        let url = MoviesEndpoint.popular().url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviePopularEndpoint_withPage_returnsURL() {
        let expectedURL = URL(string: "/movie/popular?page=1")!

        let url = MoviesEndpoint.popular(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

}
