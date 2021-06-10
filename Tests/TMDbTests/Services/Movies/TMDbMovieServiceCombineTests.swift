#if canImport(Combine)
import Combine
@testable import TMDb
import XCTest

class TMDbMovieServiceCombineTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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

    func testDetailsPublisherReturnsMovie() throws {
        let expectedResult = Movie.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.detailsPublisher(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.details(movieID: movieID).url)
    }

    func testCreditsPublisherReturnsCredits() throws {
        let expectedResult = ShowCredits.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.creditsPublisher(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.credits(movieID: movieID).url)
    }

    func testReviewsPublisherWithDefaultParametersReturnsReviews() throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.reviewsPublisher(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID).url)
    }

    func testReviewsPublisherReturnsReviews() throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.reviewsPublisher(forMovie: movieID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID).url)
    }

    func testReviewsPublisherWithPageReturnsReviews() throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.reviewsPublisher(forMovie: movieID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID, page: page).url)
    }

    func testImagesPublisherReturnsImageCollection() throws {
        let expectedResult = ImageCollection.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.imagesPublisher(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.images(movieID: movieID).url)
    }

    func testVideosPublisherReturnsVideoCollection() throws {
        let expectedResult = VideoCollection.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.videosPublisher(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.videos(movieID: movieID).url)
    }

    func testRecommendationsPublisherWithDefaultParametersReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.recommendationsPublisher(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID).url)
    }

    func testRecommendationsPublisherReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.recommendationsPublisher(forMovie: movieID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID).url)
    }

    func testRecommendationsPublisherWithPageReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.recommendationsPublisher(forMovie: movieID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID, page: page).url)
    }

    func testSimilarPublisherWithDefaultParametersReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.similarPublisher(toMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID).url)
    }

    func testSimilarPublisherReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.similarPublisher(toMovie: movieID, page: nil),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID).url)
    }

    func testSimilarPublisherWithPageReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.similarPublisher(toMovie: movieID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID, page: page).url)
    }

    func testNowPlayingPublisherWithDefaultParametersReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.nowPlayingPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying().url)
    }

    func testNowPlayingPublisherReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.nowPlayingPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying().url)
    }

    func testNowPlayingPublisherWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.nowPlayingPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying(page: page).url)
    }

    func testPopularPublisherWithDefaultParametersReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.popularPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular().url)
    }

    func testPopularPublisherReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.popularPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular().url)
    }

    func testPopularPublisherWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.popularPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular(page: page).url)
    }

    func testTopRatedPublisherWithDefaultParametersReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.topRatedPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated().url)
    }

    func testTopRatedPublisherReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.topRatedPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated().url)
    }

    func testTopRatedPublisherWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.topRatedPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated(page: page).url)
    }

    func testUpcomingPublisherWithDefaultParametersReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.upcomingPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming().url)
    }

    func testUpcomingPublisherReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.upcomingPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming().url)
    }

    func testUpcomingPublisherWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.upcomingPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming(page: page).url)
    }

}
#endif
