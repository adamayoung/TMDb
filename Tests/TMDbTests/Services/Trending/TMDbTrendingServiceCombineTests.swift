#if canImport(Combine)
import Combine
@testable import TMDb
import XCTest

final class TMDbTrendingServiceCombineTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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

    func testMoviesPublisherWithDefaultParametersReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.moviesPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testMoviesPublisherForDayReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.moviesPublisher(inTimeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testMoviesPublisherForDayWithPageReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.moviesPublisher(inTimeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).url)
    }

    func testMoviesPublisherForWeekReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.moviesPublisher(inTimeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testMoviesPublisherForWeekWithPageReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.moviesPublisher(inTimeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).url)
    }

    func testTVShowsPublisherWithDefaultReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.tvShowsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testTVShowsPublisherForDayReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.tvShowsPublisher(inTimeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testTVShowsPublisherForDayWithPageReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.tvShowsPublisher(inTimeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page).url)
    }

    func testTVShowsPublisherForWeekReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.tvShowsPublisher(inTimeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testTVShowsPublisherForWeekWithPageReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.tvShowsPublisher(inTimeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page).url)
    }

    func testPeoplePublisherWithDefaultParametersReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.peoplePublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testPeoplePublisherForDayReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.peoplePublisher(inTimeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testPeoplePublisherForDayWithPageReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.peoplePublisher(inTimeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).url)
    }

    func testPeoplePublisherForWeekReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.peoplePublisher(inTimeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testPeoplePublisherForWeekWithPageReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.peoplePublisher(inTimeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).url)
    }

}
#endif
