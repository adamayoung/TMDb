@testable import TMDb
import XCTest

final class TMDbTrendingServiceTests: XCTestCase {

    var service: TMDbTrendingService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbTrendingService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testFetchMoviesWithDefaultValuesReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testFetchMoviesForDayReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies(inTimeWindow: timeWindow, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testFetchMoviesForDayWithPageReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies(inTimeWindow: timeWindow, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).url)
    }

    func testFetchMoviesForWeekReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies(inTimeWindow: timeWindow, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testFetchMoviesForWeekWithPageReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovies(inTimeWindow: timeWindow, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).url)
    }

    func testFetchTVShowsWithDefaultParametersReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShows { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForDayReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShows(inTimeWindow: timeWindow, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForDayWithPageReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShows(inTimeWindow: timeWindow, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page).url)
    }

    func testFetchTVShowsForWeekReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShows(inTimeWindow: timeWindow, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForWeekWithPageReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShows(inTimeWindow: timeWindow, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page).url)
    }

    func testFetchPeopleWithDefaultParametersReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPeople { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testFetchPeopleForDayReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPeople(inTimeWindow: timeWindow, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testFetchPeopleForDayWithPageReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPeople(inTimeWindow: timeWindow, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).url)
    }

    func testFetchPeopleForWeekReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPeople(inTimeWindow: timeWindow, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testFetchPeopleForWeekWithPageReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPeople(inTimeWindow: timeWindow, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).url)
    }

}
