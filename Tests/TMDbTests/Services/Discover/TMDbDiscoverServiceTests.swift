@testable import TMDb
import XCTest

class TMDbDiscoverServiceTests: XCTestCase {

    var service: TMDbDiscoverService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbDiscoverService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testFetchMoviesWithDefaultParametersReturnsMovies() {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().url)
    }

    func testFetchMoviesReturnsMovies() {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies(sortedBy: nil, withPeople: nil, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().url)
    }

    func testFetchMoviesWithSortByReturnsMovies() {
        let sortBy = MovieSort.originalTitle(descending: false)
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies(sortedBy: sortBy, withPeople: nil, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortedBy: sortBy).url)
    }

    func testFetchMoviesWithWithPeopleReturnsMovies() {
        let people: [Int] = [.randomID, .randomID, .randomID, .randomID, .randomID]
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies(sortedBy: nil, withPeople: people, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(people: people).url)
    }

    func testFetchMoviesWithWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies(sortedBy: nil, withPeople: nil, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(page: page).url)
    }

    func testFetchMoviesWithSortByAndWithPeopleAndPageReturnsMovies() throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let people: [Int] = [.randomID, .randomID, .randomID, .randomID, .randomID]
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies(sortedBy: sortBy, withPeople: people, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortedBy: sortBy, people: people, page: page).url)
    }

    func testFetchTVShowsWithDefaultParametersReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShows { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().url)
    }

    func testFetchTVShowsReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShows(sortedBy: nil, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().url)
    }

    func testFetchTVShowsWithSortByReturnsTVShows() throws {
        let sortBy = TVShowSort.firstAirDate(descending: false)
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShows(sortedBy: sortBy, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortedBy: sortBy).url)
    }

    func testTVShowsPublisherWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShows(sortedBy: nil, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(page: page).url)
    }

    func testFetchTVShowsWithSortByAndPageReturnsTVShows() throws {
        let sortBy = TVShowSort.firstAirDate(descending: false)
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShows(sortedBy: sortBy, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortedBy: sortBy, page: page).url)
    }

}
