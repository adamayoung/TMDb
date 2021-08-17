@testable import TMDb
import XCTest

final class TMDbMovieServiceTests: XCTestCase {

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

}

extension TMDbMovieServiceTests {

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

}

extension TMDbMovieServiceTests {

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

}

extension TMDbMovieServiceTests {

    func testFetchReviewsWithDefaultParametersReturnsReviews() throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchReviews(forMovie: movieID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID).url)
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

}

extension TMDbMovieServiceTests {

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

}

extension TMDbMovieServiceTests {

    func testFetchRecommendationsWithDefaultParametersReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchRecommendations(forMovie: movieID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID).url)
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

}

extension TMDbMovieServiceTests {

    func testFetchSimilarWithDefaultParametersReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchSimilar(toMovie: movieID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID).url)
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

}

extension TMDbMovieServiceTests {

    func testFetchNowPlayingWithDefaultParametersReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchNowPlaying { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying().url)
    }

    func testFetchNowPlayingReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchNowPlaying(page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying().url)
    }

    func testFetchNowPlayingWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchNowPlaying(page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.nowPlaying(page: page).url)
    }

}

extension TMDbMovieServiceTests {

    func testFetchPopularWithDefaultParametersReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPopular { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular().url)
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

extension TMDbMovieServiceTests {

    func testFetchTopRatedWithDefaultParametersReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTopRated { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated().url)
    }

    func testFetchTopRatedReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTopRated(page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated().url)
    }

    func testFetchTopRatedWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTopRated(page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.topRated(page: page).url)
    }

}

extension TMDbMovieServiceTests {

    func testFetchUpcomingWithDefaultParametersReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchUpcoming { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming().url)
    }

    func testFetchUpcomingReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchUpcoming(page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming().url)
    }

    func testFetchUpcomingWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchUpcoming(page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.upcoming(page: page).url)
    }

}
