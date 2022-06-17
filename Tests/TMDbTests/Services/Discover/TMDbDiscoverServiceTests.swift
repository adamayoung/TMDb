@testable import TMDb
import XCTest

final class TMDbDiscoverServiceTests: XCTestCase {

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
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().path)
    }

    func testMoviesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: nil, withPeople: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().path)
    }

    func testMoviesWithSortByReturnsMovies() async throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: sortBy, withPeople: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortedBy: sortBy).path)
    }

    func testMoviesWithWithPeopleReturnsMovies() async throws {
        let people: [Int] = [.randomID, .randomID, .randomID, .randomID, .randomID]
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: nil, withPeople: people, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(people: people).path)
    }

    func testMoviesWithWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: nil, withPeople: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(page: page).path)
    }

    func testMoviesWithSortByAndWithPeopleAndPageReturnsMovies() async throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let people: [Int] = [.randomID, .randomID, .randomID, .randomID, .randomID]
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: sortBy, withPeople: people, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortedBy: sortBy, people: people, page: page).path)
    }

    func testTVShowsWithDefaultParametersReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.tvShows()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().path)
    }

    func testTVShowsReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.tvShows(sortedBy: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().path)
    }

    func testTVShowsWithSortByReturnsTVShows() async throws {
        let sortBy = TVShowSort.firstAirDate(descending: false)
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try await service.tvShows(sortedBy: sortBy, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortedBy: sortBy).path)
    }

    func testTVShowsWithPageReturnsTVShows() async throws {
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.tvShows(sortedBy: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(page: page).path)
    }

    func testTVShowsWithSortByAndPageReturnsTVShows() async throws {
        let sortBy = TVShowSort.firstAirDate(descending: false)
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.tvShows(sortedBy: sortBy, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortedBy: sortBy, page: page).path)
    }

}
