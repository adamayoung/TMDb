@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class TMDbTrendingServiceTests: XCTestCase {

    #if canImport(Combine)
    var cancellables: Set<AnyCancellable> = []
    #endif
    var service: TMDbTrendingService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbTrendingService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient.reset()

        super.tearDown()
    }

}

#if canImport(Combine)
extension TMDbTrendingServiceTests {

    func testMoviesPublisherForDayReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.moviesPublisher(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testMoviesPublisherForDayWithPageReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.moviesPublisher(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).url)
    }

    func testMoviesPublisherForWeekReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.moviesPublisher(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testMoviesPublisherForWeekWithPageReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.moviesPublisher(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).url)
    }

    func testTVShowsPublisherForDayReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowsPublisher(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testTVShowsPublisherForDayWithPageReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowsPublisher(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page).url)
    }

    func testTVShowsPublisherForWeekReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVShowPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowsPublisher(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForWeekWithPageReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowsPublisher(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page).url)
    }

    func testPeoplePublisherForDayReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.peoplePublisher(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testTVShowsPublisherForDayWithPageReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.peoplePublisher(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).url)
    }

    func testPeoplePublisherForWeekReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.peoplePublisher(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testTVShowsPublisherForWeekWithPageReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.peoplePublisher(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).url)
    }

}
#endif
