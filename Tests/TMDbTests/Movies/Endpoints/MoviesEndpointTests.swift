@testable import TMDb
import XCTest

final class MoviesEndpointTests: XCTestCase {

    func testMovieDetailsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1"))

        let url = MoviesEndpoint.details(movieID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieCreditsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/credits"))

        let url = MoviesEndpoint.credits(movieID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieReviewsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/reviews"))

        let url = MoviesEndpoint.reviews(movieID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieReviewsEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/reviews?page=2"))

        let url = MoviesEndpoint.reviews(movieID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieImagesEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/images?include_image_language=\(languageCode),null"))

        let url = MoviesEndpoint.images(movieID: 1, languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieVideosEndpointReturnsURL() throws {
        let languageCode = "en"
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/videos?include_video_language=\(languageCode),null"))

        let url = MoviesEndpoint.videos(movieID: 1, languageCode: languageCode).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieRecommendationsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/recommendations"))

        let url = MoviesEndpoint.recommendations(movieID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieRecommendationsEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/recommendations?page=2"))

        let url = MoviesEndpoint.recommendations(movieID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieSimilarEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/similar"))

        let url = MoviesEndpoint.similar(movieID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieSimilarEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/similar?page=2"))

        let url = MoviesEndpoint.similar(movieID: 1, page: 2).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieNowPlayingEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/now_playing"))

        let url = MoviesEndpoint.nowPlaying().path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieNowPlayingEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/now_playing?page=1"))

        let url = MoviesEndpoint.nowPlaying(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviePopularEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/popular"))

        let url = MoviesEndpoint.popular().path

        XCTAssertEqual(url, expectedURL)
    }

    func testMoviePopularEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/popular?page=1"))

        let url = MoviesEndpoint.popular(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieTopRatedEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/top_rated"))

        let url = MoviesEndpoint.topRated().path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieTopRatedEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/top_rated?page=1"))

        let url = MoviesEndpoint.topRated(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieUpcomingEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/upcoming"))

        let url = MoviesEndpoint.upcoming().path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieUpcomingEndpointWithPageReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/upcoming?page=1"))

        let url = MoviesEndpoint.upcoming(page: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieWatchEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/watch/providers"))

        let url = MoviesEndpoint.watch(movieID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

    func testMovieExternalIDsEndpointReturnsURL() throws {
        let expectedURL = try XCTUnwrap(URL(string: "/movie/1/external_ids"))

        let url = MoviesEndpoint.externalIDs(movieID: 1).path

        XCTAssertEqual(url, expectedURL)
    }

}
