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

    func testSearchAllWithDefaultParametersReturnsMedia() async throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchAll(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query).path)
    }

    func testSearchAllReturnsMedia() async throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchAll(query: query, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query).path)
    }

    func testSearchAllWithPageReturnsMedia() async throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        let page = expectedResult.page

        apiClient.result = .success(expectedResult)

        let result = try await service.searchAll(query: query, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query, page: page).path)
    }

    func testSearchMoviesWithDefaultParametersReturnsMovies() async throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchMovies(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query).path)
    }

    func testSearchMoviesReturnsMovies() async throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchMovies(query: query, year: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query).path)
    }

    func testSearchMoviesWithYearReturnsMovies() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchMovies(query: query, year: year, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year).path)
    }

    func testSearchMoviesWithPageReturnsMovies() async throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.searchMovies(query: query, year: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, page: page).path)
    }

    func testSearchMoviesWithYearAndPageReturnsMovies() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.searchMovies(query: query, year: year, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year, page: page).path)
    }

    func testSearchTVShowsWithDefaultParametersReturnsTVShows() async throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchTVShows(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query).path)
    }

    func testSearchTVShowsReturnsTVShows() async throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchTVShows(query: query, firstAirDateYear: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query).path)
    }

    func testSearchTVShowsWithFirstAirDateYearReturnsTVShows() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchTVShows(query: query, firstAirDateYear: year, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, firstAirDateYear: year).path)
    }

    func testSearchTVShowsWithPageReturnsTVShows() async throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.searchTVShows(query: query, firstAirDateYear: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, page: page).path)
    }

    func testSearchTVShowsWithFirstAirDateYearANdPageReturnsTVShows() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.searchTVShows(query: query, firstAirDateYear: year, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath,
                       SearchEndpoint.tvShows(query: query, firstAirDateYear: year, page: page).path)
    }

    func testSearchPeopleWithDefaultParametersReturnsPeople() async throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchPeople(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query).path)
    }

    func testSearchPeopleReturnsPeople() async throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchPeople(query: query, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query).path)
    }

    func testSearchPeopleWithPageReturnsPeople() async throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.searchPeople(query: query, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query, page: page).path)
    }

}
