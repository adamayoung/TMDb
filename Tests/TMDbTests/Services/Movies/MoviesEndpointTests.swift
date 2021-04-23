@testable import TMDb
import XCTest

class MoviesEndpointTests: XCTestCase {

    func testMovieDetailsEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/1")!

        let url = MoviesEndpoint.details(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieCreditsEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/1/credits")!

        let url = MoviesEndpoint.credits(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieReviewsEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/1/reviews")!

        let url = MoviesEndpoint.reviews(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieReviewsEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/movie/1/reviews?page=2")!

        let url = MoviesEndpoint.reviews(movieID: 1, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieImagesEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/1/images")!

        let url = MoviesEndpoint.images(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieVideosEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/1/videos")!

        let url = MoviesEndpoint.videos(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieRecommendationsEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/1/recommendations")!

        let url = MoviesEndpoint.recommendations(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieRecommendationsEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/movie/1/recommendations?page=2")!

        let url = MoviesEndpoint.recommendations(movieID: 1, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieSimilarEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/1/similar")!

        let url = MoviesEndpoint.similar(movieID: 1).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieSimilarEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/movie/1/similar?page=2")!

        let url = MoviesEndpoint.similar(movieID: 1, page: 2).url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieNowPlayingEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/now_playing")!

        let url = MoviesEndpoint.nowPlaying().url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieNowPlayingEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/movie/now_playing?page=1")!

        let url = MoviesEndpoint.nowPlaying(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }
    
    func testMoviePopularEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/popular")!

        let url = MoviesEndpoint.popular().url

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviePopularEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/movie/popular?page=1")!

        let url = MoviesEndpoint.popular(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }
    
    func testMovieTopRatedEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/top_rated")!

        let url = MoviesEndpoint.topRated().url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieTopRatedEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/movie/top_rated?page=1")!

        let url = MoviesEndpoint.topRated(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }
    
    func testMovieUpcomingEndpointReturnsURL() {
        let expectedURL = URL(string: "/movie/upcoming")!

        let url = MoviesEndpoint.upcoming().url

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieUpcomingEndpointWithPageReturnsURL() {
        let expectedURL = URL(string: "/movie/upcoming?page=1")!

        let url = MoviesEndpoint.upcoming(page: 1).url

        XCTAssertEqual(url, expectedURL)
    }

}
