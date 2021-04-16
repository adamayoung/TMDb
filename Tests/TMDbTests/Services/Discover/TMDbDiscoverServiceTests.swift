@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class TMDbDiscoverServiceTests: XCTestCase {

    #if canImport(Combine)
    var cancellables: Set<AnyCancellable> = []
    #endif
    var service: TMDbDiscoverService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbDiscoverService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient.reset()

        super.tearDown()
    }

}

#if canImport(Combine)
extension TMDbDiscoverServiceTests {

    func testMoviesPublisherReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.moviesPublisher(sortBy: nil, withPeople: nil, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().url)
    }

    func testMoviesPublisherWithSortByReturnsMovies() throws {
        let sortBy = MovieSortBy.originalTitleAscending
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.moviesPublisher(sortBy: sortBy, withPeople: nil, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortBy: sortBy).url)
    }

    func testMoviesPublisherWithWithPeopleReturnsMovies() throws {
        let people = [1, 2, 3, 4, 5]
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.moviesPublisher(sortBy: nil, withPeople: people, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(people: people).url)
    }

    func testMoviesPublisherWithWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.moviesPublisher(sortBy: nil, withPeople: nil, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(page: page).url)
    }

    func testMoviesPublisherWithSortByAndWithPeopleAndPageReturnsMovies() throws {
        let sortBy = MovieSortBy.originalTitleAscending
        let people = [1, 2, 3, 4, 5]
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.moviesPublisher(sortBy: sortBy, withPeople: people, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortBy: sortBy, people: people, page: page).url)
    }

    func testTVShowsPublisherReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowsPublisher(sortBy: nil, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().url)
    }

    func testTVShowsPublisherWithSortByReturnsTVShows() throws {
        let sortBy = TVShowSortBy.firstAirDateAscending
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowsPublisher(sortBy: sortBy, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortBy: sortBy).url)
    }

    func testTVShowsPublisherWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowsPublisher(sortBy: nil, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(page: page).url)
    }

    func testTVShowsPublisherWithSortByAndPageReturnsTVShows() throws {
        let sortBy = TVShowSortBy.firstAirDateAscending
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowsPublisher(sortBy: sortBy, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortBy: sortBy, page: page).url)
    }

}
#endif
