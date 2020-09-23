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
        let expectedResult = MoviePageableListDTO(
            page: 1,
            results: [
                MovieDTO(id: 1, title: "Movie 1"),
                MovieDTO(id: 2, title: "Movie 2"),
                MovieDTO(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testFetchMoviesForDayWithPageReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let page = 2
        let expectedResult = MoviePageableListDTO(
            page: page,
            results: [
                MovieDTO(id: 1, title: "Movie 1"),
                MovieDTO(id: 2, title: "Movie 2"),
                MovieDTO(id: 3, title: "Movie 3")
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
        let expectedResult = MoviePageableListDTO(
            page: 1,
            results: [
                MovieDTO(id: 1, title: "Movie 1"),
                MovieDTO(id: 2, title: "Movie 2"),
                MovieDTO(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.movies(timeWindow: timeWindow).url)
    }

    func testFetchMoviesForWeekWithPageReturnsMovies() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let expectedResult = MoviePageableListDTO(
            page: page,
            results: [
                MovieDTO(id: 1, title: "Movie 1"),
                MovieDTO(id: 2, title: "Movie 2"),
                MovieDTO(id: 3, title: "Movie 3")
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
        let expectedResult = TVShowPageableListDTO(
            page: 1,
            results: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 2"),
                TVShowDTO(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForDayWithPageReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let page = 2
        let expectedResult = TVShowPageableListDTO(
            page: 1,
            results: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 2"),
                TVShowDTO(id: 3, name: "TV Show 3")
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
        let expectedResult = TVShowPageableListDTO(
            page: 1,
            results: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 2"),
                TVShowDTO(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.tvShows(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForWeekWithPageReturnsTVShows() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let expectedResult = TVShowPageableListDTO(
            page: 1,
            results: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 2"),
                TVShowDTO(id: 3, name: "TV Show 3")
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
        let expectedResult = PersonPageableListDTO(
            page: 1,
            results: [
                PersonDTO(id: 1, name: "Person 1"),
                PersonDTO(id: 2, name: "Person 2"),
                PersonDTO(id: 3, name: "Person 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchPeople(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForDayWithPageReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let page = 2
        let expectedResult = PersonPageableListDTO(
            page: 1,
            results: [
                PersonDTO(id: 1, name: "Person 1"),
                PersonDTO(id: 2, name: "Person 2"),
                PersonDTO(id: 3, name: "Person 3")
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
        let expectedResult = PersonPageableListDTO(
            page: 1,
            results: [
                PersonDTO(id: 1, name: "Person 1"),
                PersonDTO(id: 2, name: "Person 2"),
                PersonDTO(id: 3, name: "Person 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchPeople(timeWindow: timeWindow, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, TrendingEndpoint.people(timeWindow: timeWindow).url)
    }

    func testFetchTVShowsForWeekWithPageReturnsPeople() throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let expectedResult = PersonPageableListDTO(
            page: 1,
            results: [
                PersonDTO(id: 1, name: "Person 1"),
                PersonDTO(id: 2, name: "Person 2"),
                PersonDTO(id: 3, name: "Person 3")
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
