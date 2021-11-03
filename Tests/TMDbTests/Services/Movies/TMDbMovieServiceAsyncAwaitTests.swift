#if swift(>=5.5) && !os(Linux)
@testable import TMDb
import XCTest

@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
final class TMDbMovieServiceAsyncAwaitTests: XCTestCase {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbMovieService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsMovie() async throws {
        let expectedResult = Movie.mock
        let movieID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.details(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.details(movieID: movieID).url)
    }

    func testCreditsReturnsCredits() async throws {
        let expectedResult = ShowCredits.mock
        let movieID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.credits(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.credits(movieID: movieID).url)
    }

    func testReviewsWithDefaultParametersReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID).url)
    }

    func testReviewsReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID).url)
    }

    func testReviewsWithPageReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID, page: page).url)
    }

    func testImagesReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock
        let movieID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.images(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.images(movieID: movieID).url)
    }

    func testVideosReturnsVideoCollection() async throws {
        let expectedResult = VideoCollection.mock
        let movieID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.videos(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.videos(movieID: movieID).url)
    }

    func testRecommendationsWithDefaultParametersReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID).url)
    }

    func testRecommendationsReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID).url)
    }

    func testRecommendationsWithPageReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID, page: page).url)
    }

    func testSimilarWithDefaultParametersReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID).url)
    }

    func testSimilarReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID).url)
    }

    func testSimilarWithPageReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID, page: page).url)
    }

    func testNowPlayingWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.nowPlaying()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying().url)
    }

    func testNowPlayingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.nowPlaying(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying().url)
    }

    func testNowPlayingWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.nowPlaying(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying(page: page).url)
    }

    func testPopularWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular().url)
    }

    func testPopularReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.popular(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular().url)
    }

    func testPopularWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.popular(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular(page: page).url)
    }

    func testTopRatedWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.topRated()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated().url)
    }

    func testTopRatedReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.topRated(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated().url)
    }

    func testTopRatedWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.topRated(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated(page: page).url)
    }

    func testUpcomingWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.upcoming()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming().url)
    }

    func testUpcomingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.upcoming(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming().url)
    }

    func testUpcomingWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.upcoming(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming(page: page).url)
    }

}
#endif
