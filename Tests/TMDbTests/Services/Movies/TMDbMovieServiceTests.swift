@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class TMDbMovieServiceTests: XCTestCase {

    #if canImport(Combine)
    var cancellables: Set<AnyCancellable> = []
    #endif
    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbMovieService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient.reset()

        super.tearDown()
    }

    func testFetchDetailsReturnsMovie() throws {
        let expectedResult = Movie.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchDetails(forMovie: movieID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.details(movieID: movieID).url)
    }

    func testFetchCreditsReturnsCredits() throws {
        let expectedResult = ShowCredits.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchCredits(forMovie: movieID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.credits(movieID: movieID).url)
    }

    func testFetchReviewsReturnsReviews() throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchReviews(forMovie: movieID, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID).url)
    }

    func testFetchReviewsWithPageReturnsReviews() throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchReviews(forMovie: movieID, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID, page: page).url)
    }

    func testFetchImagesReturnsImageCollection() throws {
        let expectedResult = ImageCollection.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchImages(forMovie: movieID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.images(movieID: movieID).url)
    }

    func testFetchVideosReturnsVideoCollection() throws {
        let expectedResult = VideoCollection.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchVideos(forMovie: movieID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.videos(movieID: movieID).url)
    }

    func testFetchRecommendationsReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchRecommendations(forMovie: movieID, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID).url)
    }

    func testFetchRecommendationsWithPageReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchRecommendations(forMovie: movieID, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID, page: page).url)
    }

    func testFetchSimilarReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchSimilar(toMovie: movieID, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID).url)
    }

    func testFetchSimilarWithPageReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchSimilar(toMovie: movieID, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID, page: page).url)
    }

    func testFetchPopularReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPopular(page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular().url)
    }

    func testFetchPopularWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPopular(page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular(page: page).url)
    }

}

#if canImport(Combine)
extension TMDbMovieServiceTests {

    func testDetailsPublisherReturnsMovie() throws {
        let expectedResult = Movie.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.detailsPublisher(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.details(movieID: movieID).url)
    }

    func testCreditsPublisherReturnsCredits() throws {
        let expectedResult = ShowCredits.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.creditsPublisher(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.credits(movieID: movieID).url)
    }

    func testReviewsPublisherReturnsReviews() throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.reviewsPublisher(forMovie: movieID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID).url)
    }

    func testReviewsPublisherWithPageReturnsReviews() throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.reviewsPublisher(forMovie: movieID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID, page: page).url)
    }

    func testImagesPublisherReturnsImageCollection() throws {
        let expectedResult = ImageCollection.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.imagesPublisher(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.images(movieID: movieID).url)
    }

    func testVideosPublisherReturnsVideoCollection() throws {
        let expectedResult = VideoCollection.mock
        let movieID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.videosPublisher(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.videos(movieID: movieID).url)
    }

    func testRecommendationsPublisherReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.recommendationsPublisher(forMovie: movieID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID).url)
    }

    func testRecommendationsPublisherWithPageReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.recommendationsPublisher(forMovie: movieID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID, page: page).url)
    }

    func testSimilarPublisherReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.similarPublisher(toMovie: movieID, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID).url)
    }

    func testSimilarPublisherWithPageReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.similarPublisher(toMovie: movieID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID, page: page).url)
    }

    func testPopularPublisherReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.popularPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular().url)
    }

    func testPopularPublisherWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.popularPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular(page: page).url)
    }

}
#endif
