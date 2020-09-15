import Combine
@testable import TMDb
import XCTest

class TMDbSearchServiceTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var service: TMDbSearchService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbSearchService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient.reset()

        super.tearDown()
    }

    func testSearchAllReturnsMedia() throws {
        let query = "some search string"
        let expectedResult = MediaPageableList(
            page: 1,
            results: [
                .movie(Movie(id: 1, title: "Movie 1")),
                .tvShow(TVShow(id: 2, name: "TV Show 2")),
                .person(Person(id: 3, name: "Person 3"))
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchAll(query: query), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query).url)
    }

    func testSearchAllWithPageReturnsMedia() throws {
        let query = "some search string"
        let page = 2
        let expectedResult = MediaPageableList(
            page: page,
            results: [
                .movie(Movie(id: 1, title: "Movie 1")),
                .tvShow(TVShow(id: 2, name: "TV Show 2")),
                .person(Person(id: 3, name: "Person 3"))
            ],
            totalResults: 3,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchAll(query: query, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query, page: page).url)
    }

    func testSearchMoviesReturnsMovies() throws {
        let query = "some search string"
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

        let result = try await(publisher: service.searchMovies(query: query), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query).url)
    }

    func testSearchMoviesWithYearReturnsMovies() throws {
        let query = "some search string"
        let year = 2020
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

        let result = try await(publisher: service.searchMovies(query: query, year: year), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year).url)
    }

    func testSearchMoviesWithPageReturnsMovies() throws {
        let query = "some search string"
        let page = 2
        let expectedResult = MoviePageableList(
            page: page,
            results: [
                Movie(id: 1, title: "Movie 1"),
                Movie(id: 2, title: "Movie 2"),
                Movie(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchMovies(query: query, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, page: page).url)
    }

    func testSearchMoviesWithYearAndPageReturnsMovies() throws {
        let query = "some search string"
        let year = 2020
        let page = 2
        let expectedResult = MoviePageableList(
            page: page,
            results: [
                Movie(id: 1, title: "Movie 1"),
                Movie(id: 2, title: "Movie 2"),
                Movie(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchMovies(query: query, year: year, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year, page: page).url)
    }

    func testSearchTVShowsReturnsTVShows() throws {
        let query = "some search string"
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 1"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchTVShows(query: query), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query).url)
    }

    func testSearchTVShowsWithFirstAirDateYearReturnsTVShows() throws {
        let query = "some search string"
        let year = 2020
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 1"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchTVShows(query: query, firstAirDateYear: year),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, firstAirDateYear: year).url)
    }

    func testSearchTVShowsWithPageReturnsTVShows() throws {
        let query = "some search string"
        let page = 2
        let expectedResult = TVShowPageableList(
            page: page,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 1"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchTVShows(query: query, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, page: page).url)
    }

    func testSearchTVShowsWithFirstAirDateYearANdPageReturnsTVShows() throws {
        let query = "some search string"
        let year = 2020
        let page = 2
        let expectedResult = TVShowPageableList(
            page: page,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 1"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchTVShows(query: query, firstAirDateYear: year, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, firstAirDateYear: year, page: page).url)
    }

    func testSearchPeopleReturnsPeople() throws {
        let query = "some search string"
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

        let result = try await(publisher: service.searchPeople(query: query), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query).url)
    }

    func testSearchPeopleWithPageReturnsPeople() throws {
        let query = "some search string"
        let page = 2
        let expectedResult = PersonPageableList(
            page: page,
            results: [
                Person(id: 1, name: "Person 1"),
                Person(id: 2, name: "Person 2"),
                Person(id: 3, name: "Person 3")
            ],
            totalResults: 3,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchPeople(query: query, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query, page: page).url)
    }

}
