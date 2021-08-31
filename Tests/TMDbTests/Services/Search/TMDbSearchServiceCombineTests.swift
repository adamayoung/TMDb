#if canImport(Combine)
import Combine
@testable import TMDb
import XCTest

final class TMDbSearchServiceCombineTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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

    func testSearchAllPublisherWithDefaultParametersReturnsMedia() throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchAllPublisher(query: query), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query).url)
    }

    func testSearchAllPublisherReturnsMedia() throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchAllPublisher(query: query, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query).url)
    }

    func testSearchAllPublisherWithPageReturnsMedia() throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock
        let page = expectedResult.page

        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchAllPublisher(query: query, page: page),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query, page: page).url)
    }

    func testSearchMoviesPublisherWithDefaultParametersReturnsMovies() throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchMoviesPublisher(query: query),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query).url)
    }

    func testSearchMoviesPublisherReturnsMovies() throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchMoviesPublisher(query: query, year: nil, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query).url)
    }

    func testSearchMoviesPublisherWithYearReturnsMovies() throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchMoviesPublisher(query: query, year: year, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year).url)
    }

    func testSearchMoviesPublisherWithPageReturnsMovies() throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchMoviesPublisher(query: query, year: nil, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, page: page).url)
    }

    func testSearchMoviesPublisherWithYearAndPageReturnsMovies() throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchMoviesPublisher(query: query, year: year, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year, page: page).url)
    }

    func testSearchTVShowsPublisherWithDefaultParametersReturnsTVShows() throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchTVShowsPublisher(query: query), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query).url)
    }

    func testSearchTVShowsPublisherReturnsTVShows() throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchTVShowsPublisher(query: query, firstAirDateYear: nil,
                                                                         page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query).url)
    }

    func testSearchTVShowsPublisherWithFirstAirDateYearReturnsTVShows() throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchTVShowsPublisher(query: query, firstAirDateYear: year,
                                                                         page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, firstAirDateYear: year).url)
    }

    func testSearchTVShowsPublisherWithPageReturnsTVShows() throws {
        let query = String.randomString
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchTVShowsPublisher(query: query, firstAirDateYear: nil,
                                                                         page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, page: page).url)
    }

    func testSearchTVShowsPublisherWithFirstAirDateYearANdPageReturnsTVShows() throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchTVShowsPublisher(query: query, firstAirDateYear: year,
                                                                         page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, firstAirDateYear: year, page: page).url)
    }

    func testSearchPeoplePublisherWithDefaultParametersReturnsPeople() throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchPeoplePublisher(query: query), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query).url)
    }

    func testSearchPeoplePublisherReturnsPeople() throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchPeoplePublisher(query: query, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query).url)
    }

    func testSearchPeoplePublisherWithPageReturnsPeople() throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.searchPeoplePublisher(query: query, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query, page: page).url)
    }

}
#endif
