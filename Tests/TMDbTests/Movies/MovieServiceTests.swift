@testable import TMDb
import XCTest

final class MovieServiceTests: XCTestCase {

    var service: MovieService!
    var apiClient: MockAPIClient!
    var locale: Locale!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        locale = Locale(identifier: "en_GB")
        service = MovieService(apiClient: apiClient, localeProvider: { [unowned self] in locale })
    }

    override func tearDown() {
        apiClient = nil
        locale = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsMovie() async throws {
        let expectedResult = Movie.thorLoveAndThunder
        let movieID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.details(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.details(movieID: movieID).path)
    }

    func testCreditsReturnsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let movieID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.credits(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.credits(movieID: movieID).path)
    }

    func testReviewsWithDefaultParametersReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID).path)
    }

    func testReviewsReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID).path)
    }

    func testReviewsWithPageReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.reviews(forMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID, page: page).path)
    }

    func testImagesReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock()
        let movieID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.images(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastPath,
            MoviesEndpoint.images(movieID: movieID, languageCode: locale.languageCode).path
        )
    }

    func testVideosReturnsVideoCollection() async throws {
        let expectedResult = VideoCollection.mock()
        let movieID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let result = try await service.videos(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastPath,
            MoviesEndpoint.videos(movieID: movieID, languageCode: locale.languageCode).path
        )
    }

    func testRecommendationsWithDefaultParametersReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID).path)
    }

    func testRecommendationsReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID).path)
    }

    func testRecommendationsWithPageReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.recommendations(forMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID, page: page).path)
    }

    func testSimilarWithDefaultParametersReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID).path)
    }

    func testSimilarReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID).path)
    }

    func testSimilarWithPageReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.similar(toMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID, page: page).path)
    }

    func testNowPlayingWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.nowPlaying()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying().path)
    }

    func testNowPlayingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.nowPlaying(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying().path)
    }

    func testNowPlayingWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.nowPlaying(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying(page: page).path)
    }

    func testPopularWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular().path)
    }

    func testPopularReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.popular(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular().path)
    }

    func testPopularWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.popular(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular(page: page).path)
    }

    func testTopRatedWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.topRated()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated().path)
    }

    func testTopRatedReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.topRated(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated().path)
    }

    func testTopRatedWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.topRated(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated(page: page).path)
    }

    func testUpcomingWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.upcoming()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming().path)
    }

    func testUpcomingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.upcoming(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming().path)
    }

    func testUpcomingWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.upcoming(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming(page: page).path)
    }

    func testWatchReturnsWatchProviders() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let movieID = 1
        apiClient.result = .success(expectedResult)

        let result = try await service.watchProviders(forMovie: movieID)

        let regionCode = try XCTUnwrap(locale.regionCode)
        XCTAssertEqual(result, expectedResult.results[regionCode])
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.watch(movieID: movieID).path)
    }

    func testExternalLinksReturnsExternalLinks() async throws {
        let expectedResult = MovieExternalLinksCollection.barbie
        let movieID = 346698
        apiClient.result = .success(expectedResult)

        let result = try await service.externalLinks(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.externalIDs(movieID: movieID).path)
    }

}
