@testable import TMDb
import XCTest

final class TMDbSearchServiceTests: XCTestCase {

    var service: TMDbSearchService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbSearchService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testFetchSearchAllWithDefaultParametersReturnsMedia() throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchAll(query: query) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query).url)
    }

    func testFetchSearchAllReturnsMedia() throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchAll(query: query, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query).url)
    }

    func testFetchSearchAllWithPageReturnsMedia() throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        let page = expectedResult.page

        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchAll(query: query, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query, page: page).url)
    }

    func testFetchSearchMoviesWithDefaultParametersReturnsMovies() throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchMovies(query: query) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query).url)
    }

    func testFetchSearchMoviesReturnsMovies() throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchMovies(query: query, year: nil, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query).url)
    }

    func testFetchSearchMoviesWithYearReturnsMovies() throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchMovies(query: query, year: year, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year).url)
    }

    func testFetchSearchMoviesWithPageReturnsMovies() throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchMovies(query: query, year: nil, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, page: page).url)
    }

    func testFetchSearchMoviesWithYearAndPageReturnsMovies() throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchMovies(query: query, year: year, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year, page: page).url)
    }

    func testFetchSearchTVShowsWithDefaultParametersReturnsTVShows() throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchTVShows(query: query) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query).url)
    }

    func testFetchSearchTVShowsReturnsTVShows() throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchTVShows(query: query, firstAirDateYear: nil, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query).url)
    }

    func testFetchSearchTVShowsWithFirstAirDateYearReturnsTVShows() throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchTVShows(query: query, firstAirDateYear: year, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, firstAirDateYear: year).url)
    }

    func testFetchSearchTVShowsWithPageReturnsTVShows() throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchTVShows(query: query, firstAirDateYear: nil, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, page: page).url)
    }

    func testFetchSearchTVShowsWithFirstAirDateYearANdPageReturnsTVShows() throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchTVShows(query: query, firstAirDateYear: year, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, firstAirDateYear: year, page: page).url)
    }

    func testFetchSearchPeopleWithDefaultParametersReturnsPeople() throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchPeople(query: query) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query).url)
    }

    func testFetchSearchPeopleReturnsPeople() throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchPeople(query: query, page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query).url)
    }

    func testFetchSearchPeopleWithPageReturnsPeople() throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.searchPeople(query: query, page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query, page: page).url)
    }

}
