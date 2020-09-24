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
        let expectedResult = MediaPageableListDTO(
            page: 1,
            results: [
                .movie(MovieDTO(id: 1, title: "Movie 1")),
                .tvShow(TVShowDTO(id: 2, name: "TV Show 2")),
                .person(PersonDTO(id: 3, name: "Person 3"))
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchAll(query: query, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.multi(query: query).url)
    }

    func testSearchAllWithPageReturnsMedia() throws {
        let query = "some search string"
        let page = 2
        let expectedResult = MediaPageableListDTO(
            page: page,
            results: [
                .movie(MovieDTO(id: 1, title: "Movie 1")),
                .tvShow(TVShowDTO(id: 2, name: "TV Show 2")),
                .person(PersonDTO(id: 3, name: "Person 3"))
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

        let result = try await(publisher: service.searchMovies(query: query, year: nil, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query).url)
    }

    func testSearchMoviesWithYearReturnsMovies() throws {
        let query = "some search string"
        let year = 2020
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

        let result = try await(publisher: service.searchMovies(query: query, year: year, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, year: year).url)
    }

    func testSearchMoviesWithPageReturnsMovies() throws {
        let query = "some search string"
        let page = 2
        let expectedResult = MoviePageableListDTO(
            page: page,
            results: [
                MovieDTO(id: 1, title: "Movie 1"),
                MovieDTO(id: 2, title: "Movie 2"),
                MovieDTO(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchMovies(query: query, year: nil, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.movies(query: query, page: page).url)
    }

    func testSearchMoviesWithYearAndPageReturnsMovies() throws {
        let query = "some search string"
        let year = 2020
        let page = 2
        let expectedResult = MoviePageableListDTO(
            page: page,
            results: [
                MovieDTO(id: 1, title: "Movie 1"),
                MovieDTO(id: 2, title: "Movie 2"),
                MovieDTO(id: 3, title: "Movie 3")
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
        let expectedResult = TVShowPageableListDTO(
            page: 1,
            results: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 1"),
                TVShowDTO(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchTVShows(query: query, firstAirDateYear: nil, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query).url)
    }

    func testSearchTVShowsWithFirstAirDateYearReturnsTVShows() throws {
        let query = "some search string"
        let year = 2020
        let expectedResult = TVShowPageableListDTO(
            page: 1,
            results: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 1"),
                TVShowDTO(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchTVShows(query: query, firstAirDateYear: year, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, firstAirDateYear: year).url)
    }

    func testSearchTVShowsWithPageReturnsTVShows() throws {
        let query = "some search string"
        let page = 2
        let expectedResult = TVShowPageableListDTO(
            page: page,
            results: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 1"),
                TVShowDTO(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.searchTVShows(query: query, firstAirDateYear: nil, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.tvShows(query: query, page: page).url)
    }

    func testSearchTVShowsWithFirstAirDateYearANdPageReturnsTVShows() throws {
        let query = "some search string"
        let year = 2020
        let page = 2
        let expectedResult = TVShowPageableListDTO(
            page: page,
            results: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 1"),
                TVShowDTO(id: 3, name: "TV Show 3")
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

        let result = try await(publisher: service.searchPeople(query: query, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, SearchEndpoint.people(query: query).url)
    }

    func testSearchPeopleWithPageReturnsPeople() throws {
        let query = "some search string"
        let page = 2
        let expectedResult = PersonPageableListDTO(
            page: page,
            results: [
                PersonDTO(id: 1, name: "Person 1"),
                PersonDTO(id: 2, name: "Person 2"),
                PersonDTO(id: 3, name: "Person 3")
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
