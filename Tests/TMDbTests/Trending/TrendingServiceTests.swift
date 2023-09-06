@testable import TMDb
import XCTest

final class TrendingServiceTests: XCTestCase {

    var service: TrendingService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TrendingService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testMoviesWithDefaultParametersReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.movies()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).path)
    }

    func testMoviesForDayReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).path)
    }

    func testMoviesForDayWithPageReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).path)
    }

    func testMoviesForWeekReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).path)
    }

    func testMoviesForWeekWithPageReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).path)
    }

    func testTVSeriesWithDefaultReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.tvSeries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvSeries(timeWindow: timeWindow).path)
    }

    func testTVSeriesForDayReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.tvSeries(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvSeries(timeWindow: timeWindow).path)
    }

    func testTVSeriesForDayWithPageReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.tvSeries(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvSeries(timeWindow: timeWindow, page: page).path)
    }

    func testTVSeriesForWeekReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.tvSeries(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvSeries(timeWindow: timeWindow).path)
    }

    func testTVSeriesForWeekWithPageReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.tvSeries(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvSeries(timeWindow: timeWindow, page: page).path)
    }

    func testPeopleWithDefaultParametersReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.people()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).path)
    }

    func testPeopleForDayReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.people(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).path)
    }

    func testPeopleForDayWithPageReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.people(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).path)
    }

    func testPeopleForWeekReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.people(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).path)
    }

    func testPeopleForWeekWithPageReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.people(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).path)
    }

}
