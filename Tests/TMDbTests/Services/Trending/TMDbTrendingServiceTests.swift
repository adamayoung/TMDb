import Combine
@testable import TMDb
import XCTest

class TMDbTrendingServiceTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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

    func testFetchMoviesForDayReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList(
            page: 1,
            results: [
                Movie(id: 1, title: "Movie 1"),
                Movie(id: 2, title: "Movie 2"),
                Movie(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(timeWindow: timeWindow), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testFetchMoviesForDayWithPageReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let page = 2
        let expectedResult = MoviePageableList(
            page: page,
            results: [
                Movie(id: 1, title: "Movie 1"),
                Movie(id: 2, title: "Movie 2"),
                Movie(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).url)
    }

    func testFetchMoviesForWeekReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList(
            page: 1,
            results: [
                Movie(id: 1, title: "Movie 1"),
                Movie(id: 2, title: "Movie 2"),
                Movie(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(timeWindow: timeWindow), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testFetchMoviesForWeekWithPageReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let expectedResult = MoviePageableList(
            page: page,
            results: [
                Movie(id: 1, title: "Movie 1"),
                Movie(id: 2, title: "Movie 2"),
                Movie(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).url)
    }

    func testFetchTVShowsForDayReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 2"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(timeWindow: timeWindow), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForDayWithPageReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let page = 2
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 2"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page).url)
    }

    func testFetchTVShowsForWeekReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 2"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(timeWindow: timeWindow), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForWeekWithPageReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 2"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page).url)
    }

    func testFetchPeopleForDayReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList(
            page: 1,
            results: [
                Person(id: 1, name: "Person 1"),
                Person(id: 2, name: "Person 2"),
                Person(id: 3, name: "Person 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchPeople(timeWindow: timeWindow), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForDayWithPageReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let page = 2
        let expectedResult = PersonPageableList(
            page: 1,
            results: [
                Person(id: 1, name: "Person 1"),
                Person(id: 2, name: "Person 2"),
                Person(id: 3, name: "Person 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchPeople(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).url)
    }

    func testFetchPeopleForWeekReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList(
            page: 1,
            results: [
                Person(id: 1, name: "Person 1"),
                Person(id: 2, name: "Person 2"),
                Person(id: 3, name: "Person 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchPeople(timeWindow: timeWindow), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForWeekWithPageReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let expectedResult = PersonPageableList(
            page: 1,
            results: [
                Person(id: 1, name: "Person 1"),
                Person(id: 2, name: "Person 2"),
                Person(id: 3, name: "Person 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchPeople(timeWindow: timeWindow, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow, page: page).url)
    }

}
