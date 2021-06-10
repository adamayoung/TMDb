@testable import TMDb
import XCTest

class TMDbTVShowServiceTests: XCTestCase {

    var service: TMDbTVShowService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbTVShowService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testFetchDetailsReturnsTVShow() throws {
        let expectedResult = TVShow.mock
        let tvShowID = expectedResult.id
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchDetails(forTVShow: tvShowID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.details(tvShowID: tvShowID).url)
    }

    func testFetchCreditsReturnsShowsCredits() throws {
        let expectedResult = ShowCredits.mock
        let tvShowID = expectedResult.id
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchCredits(forTVShow: tvShowID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.credits(tvShowID: tvShowID).url)
    }

    func testFetchReviewsWithDefaultParametersReturnsReviews() throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchReviews(forTVShow: tvShowID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID).url)
    }

    func testFetchReviewsReturnsReviews() throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchReviews(forTVShow: tvShowID, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID).url)
    }

    func testFetchReviewsWithPageReturnsReviews() throws {
        let tvShowID = Int.randomID
        let expectedResult = ReviewPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchReviews(forTVShow: tvShowID, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page).url)
    }

    func testFetchImagesReturnsImages() throws {
        let tvShowID = Int.randomID
        let expectedResult = ImageCollection.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchImages(forTVShow: tvShowID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.images(tvShowID: tvShowID).url)
    }

    func testFetchVideosReturnsVideos() throws {
        let expectedResult = VideoCollection.mock
        let tvShowID = expectedResult.id
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchVideos(forTVShow: tvShowID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.videos(tvShowID: tvShowID).url)
    }

    func testFetchRecommendationsWithDefaultParametersReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchRecommendations(forTVShow: tvShowID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID).url)
    }

    func testFetchRecommendationsReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchRecommendations(forTVShow: tvShowID, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID).url)
    }

    func testFetchRecommendationsWithPageReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchRecommendations(forTVShow: tvShowID, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page).url)
    }

    func testFetchSimilarWithDefaultParametersReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchSimilar(toTVShow: tvShowID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID).url)
    }

    func testFetchSimilarReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchSimilar(toTVShow: tvShowID, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID).url)
    }

    func testFetchSimilarWithPageReturnsTVShows() throws {
        let tvShowID = Int.randomID
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchSimilar(toTVShow: tvShowID, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.similar(tvShowID: tvShowID, page: page).url)
    }

    func testFetchPopularWithDefaultParametersReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPopular { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular().url)
    }

    func testFetchPopularReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPopular(page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular().url)
    }

    func testFetchPopularWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPopular(page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TVShowsEndpoint.popular(page: page).url)
    }

}
