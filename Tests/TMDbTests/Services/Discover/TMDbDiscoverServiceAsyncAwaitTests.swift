#if swift(>=5.5)
@testable import TMDb
import XCTest

@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
final class TMDbDiscoverServiceAsyncAwaitTests: XCTestCase {

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

    func testMoviesWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.movies()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().url)
    }

    func testMoviesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: nil, withPeople: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().url)
    }

    func testMoviesWithSortByReturnsMovies() async throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: sortBy, withPeople: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortedBy: sortBy).url)
    }

    func testMoviesWithWithPeopleReturnsMovies() async throws {
        let people: [Int] = [.randomID, .randomID, .randomID, .randomID, .randomID]
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: nil, withPeople: people, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(people: people).url)
    }

    func testMoviesWithWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: nil, withPeople: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(page: page).url)
    }

    func testMoviesWithSortByAndWithPeopleAndPageReturnsMovies() async throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let people: [Int] = [.randomID, .randomID, .randomID, .randomID, .randomID]
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: sortBy, withPeople: people, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortedBy: sortBy, people: people, page: page).url)
    }

    func testTVShowsWithDefaultParametersReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.tvShows()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().url)
    }

    func testTVShowsReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.tvShows(sortedBy: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().url)
    }

    func testTVShowsWithSortByReturnsTVShows() async throws {
        let sortBy = TVShowSort.firstAirDate(descending: false)
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.tvShows(sortedBy: sortBy, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortedBy: sortBy).url)
    }

    func testTVShowsWithPageReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.tvShows(sortedBy: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(page: page).url)
    }

    func testTVShowsWithSortByAndPageReturnsTVShows() async throws {
        let sortBy = TVShowSort.firstAirDate(descending: false)
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.tvShows(sortedBy: sortBy, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortedBy: sortBy, page: page).url)
    }

}
#endif
