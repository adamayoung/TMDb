#if swift(>=5.5) && !os(Linux)
@testable import TMDb
import XCTest

@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
final class TMDbSearchServiceAsyncAwaitTests: XCTestCase {

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
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query).url)
    }

    func testSearchAllReturnsMedia() async throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchAll(query: query, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query).url)
    }

    func testSearchAllWithPageReturnsMedia() async throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        let page = expectedResult.page

        apiClient.result = .success(expectedResult)

        let result = try await service.searchAll(query: query, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query, page: page).url)
    }

    func testSearchMoviesWithDefaultParametersReturnsMovies() async throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchMovies(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query).url)
    }

    func testSearchMoviesReturnsMovies() async throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchMovies(query: query, year: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query).url)
    }

    func testSearchMoviesWithYearReturnsMovies() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchMovies(query: query, year: year, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year).url)
    }

    func testSearchMoviesWithPageReturnsMovies() async throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.searchMovies(query: query, year: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, page: page).url)
    }

    func testSearchMoviesWithYearAndPageReturnsMovies() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.searchMovies(query: query, year: year, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year, page: page).url)
    }

    func testSearchTVShowsWithDefaultParametersReturnsTVShows() async throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchTVShows(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query).url)
    }

    func testSearchTVShowsReturnsTVShows() async throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchTVShows(query: query, firstAirDateYear: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query).url)
    }

    func testSearchTVShowsWithFirstAirDateYearReturnsTVShows() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchTVShows(query: query, firstAirDateYear: year, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, firstAirDateYear: year).url)
    }

    func testSearchTVShowsWithPageReturnsTVShows() async throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.searchTVShows(query: query, firstAirDateYear: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, page: page).url)
    }

    func testSearchTVShowsWithFirstAirDateYearANdPageReturnsTVShows() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.searchTVShows(query: query, firstAirDateYear: year, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, firstAirDateYear: year, page: page).url)
    }

    func testSearchPeopleWithDefaultParametersReturnsPeople() async throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchPeople(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query).url)
    }

    func testSearchPeopleReturnsPeople() async throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.searchPeople(query: query, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query).url)
    }

    func testSearchPeopleWithPageReturnsPeople() async throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.searchPeople(query: query, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query, page: page).url)
    }

}
#endif
