#if swift(>=5.5)
@testable import TMDb
import XCTest

@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
final class TMDbTrendingServiceAsyncAwaitTests: XCTestCase {

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

    func testMoviesWithDefaultParametersReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await service.movies()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testMoviesForDayReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await service.movies(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testMoviesForDayWithPageReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await service.movies(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).url)
    }

    func testMoviesForWeekReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await service.movies(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testMoviesForWeekWithPageReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await service.movies(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).url)
    }

    func testTVShowsWithDefaultReturnsTVShows() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try await service.tvShows()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testTVShowsForDayReturnsTVShows() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try await service.tvShows(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testTVShowsForDayWithPageReturnsTVShows() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await service.tvShows(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page).url)
    }

    func testTVShowsForWeekReturnsTVShows() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try await service.tvShows(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testTVShowsForWeekWithPageReturnsTVShows() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await service.tvShows(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page).url)
    }

    func testPeopleWithDefaultParametersReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try await service.people()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testPeopleForDayReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try await service.people(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testPeopleForDayWithPageReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await service.people(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).url)
    }

    func testPeopleForWeekReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try await service.people(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testPeopleForWeekWithPageReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await service.people(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).url)
    }

}
#endif
