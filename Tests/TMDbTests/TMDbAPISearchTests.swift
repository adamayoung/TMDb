import Combine
@testable import TMDb
import XCTest

class TMDbAPISearchTests: TMDbAPITestCase {

    func testSearchPublisherReturnsMedia() throws {
        let expectedResult = MediaPageableListDTO(
            page: 2,
            results: [
                .movie(MovieDTO(id: 1, title: "Title 1")),
                .tvShow(TVShowDTO(id: 2, name: "Name 1")),
                .person(PersonDTO(id: 3, name: "Person Name 1"))
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.media = expectedResult
        let expectedQuery = "some query"

        let result = try await(publisher: tmdb.searchPublisher(withQuery: expectedQuery), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchAllQuery, expectedQuery)
        XCTAssertNil(searchService.lastSearchAllPage)
    }

    func testSearchPublisherWithPageReturnsMedia() throws {
        let expectedResult = MediaPageableListDTO(
            page: 2,
            results: [
                .movie(MovieDTO(id: 1, title: "Title 1")),
                .tvShow(TVShowDTO(id: 2, name: "Name 1")),
                .person(PersonDTO(id: 3, name: "Person Name 1"))
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.media = expectedResult
        let expectedQuery = "some query"
        let expectedPage = 2

        let result = try await(publisher: tmdb.searchPublisher(withQuery: expectedQuery, page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchAllQuery, expectedQuery)
        XCTAssertEqual(searchService.lastSearchAllPage, expectedPage)
    }

}

extension TMDbAPISearchTests {

    func testSearchMoviesPublisherReturnsMovies() throws {
        let expectedResult = MoviePageableListDTO(
            page: 2,
            results: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2"),
                MovieDTO(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.movies = expectedResult
        let expectedQuery = "some query"

        let result = try await(publisher: tmdb.searchMoviesPublisher(withQuery: expectedQuery), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchMoviesQuery, expectedQuery)
        XCTAssertNil(searchService.lastSearchMoviesYear)
        XCTAssertNil(searchService.lastSearchMoviesPage)
    }

    func testSearchMoviesPublisherWithYearReturnsMovies() throws {
        let expectedResult = MoviePageableListDTO(
            page: 2,
            results: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2"),
                MovieDTO(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.movies = expectedResult
        let expectedQuery = "some query"
        let expectedYear = 2020

        let result = try await(publisher: tmdb.searchMoviesPublisher(withQuery: expectedQuery, year: expectedYear),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchMoviesQuery, expectedQuery)
        XCTAssertEqual(searchService.lastSearchMoviesYear, expectedYear)
        XCTAssertNil(searchService.lastSearchMoviesPage)
    }

    func testSearchMoviesPublisherWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableListDTO(
            page: 2,
            results: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2"),
                MovieDTO(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.movies = expectedResult
        let expectedQuery = "some query"
        let expectedPage = 2

        let result = try await(publisher: tmdb.searchMoviesPublisher(withQuery: expectedQuery, page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchMoviesQuery, expectedQuery)
        XCTAssertNil(searchService.lastSearchMoviesYear)
        XCTAssertEqual(searchService.lastSearchMoviesPage, expectedPage)
    }

    func testSearchMoviesPublisherWithYearPageReturnsMovies() throws {
        let expectedResult = MoviePageableListDTO(
            page: 2,
            results: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2"),
                MovieDTO(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.movies = expectedResult
        let expectedQuery = "some query"
        let expectedYear = 2020
        let expectedPage = 2

        let result = try await(
            publisher: tmdb.searchMoviesPublisher(withQuery: expectedQuery, year: expectedYear, page: expectedPage),
            storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchMoviesQuery, expectedQuery)
        XCTAssertEqual(searchService.lastSearchMoviesYear, expectedYear)
        XCTAssertEqual(searchService.lastSearchMoviesPage, expectedPage)
    }

}

extension TMDbAPISearchTests {

    func testSearchTVShowsPublisherReturnsTVShows() throws {
        let expectedResult = TVShowPageableListDTO(
            page: 2,
            results: [
                TVShowDTO(id: 1, name: "Title 1"),
                TVShowDTO(id: 2, name: "Title 2"),
                TVShowDTO(id: 3, name: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.tvShows = expectedResult
        let expectedQuery = "some query"

        let result = try await(publisher: tmdb.searchTVShowsPublisher(withQuery: expectedQuery), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchTVShowsQuery, expectedQuery)
        XCTAssertNil(searchService.lastSearchTVShowsFirstAirDateYear)
        XCTAssertNil(searchService.lastSearchTVShowsPage)
    }

    func testSearchTVShowsPublisherWithFirstAirDateYearReturnsTVShows() throws {
        let expectedResult = TVShowPageableListDTO(
            page: 2,
            results: [
                TVShowDTO(id: 1, name: "Title 1"),
                TVShowDTO(id: 2, name: "Title 2"),
                TVShowDTO(id: 3, name: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.tvShows = expectedResult
        let expectedQuery = "some query"
        let expectedYear = 2020

        let result = try await(
            publisher: tmdb.searchTVShowsPublisher(withQuery: expectedQuery, firstAirDateYear: expectedYear),
            storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchTVShowsQuery, expectedQuery)
        XCTAssertEqual(searchService.lastSearchTVShowsFirstAirDateYear, expectedYear)
        XCTAssertNil(searchService.lastSearchTVShowsPage)
    }

    func testSearchTVShowsPublisherWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableListDTO(
            page: 2,
            results: [
                TVShowDTO(id: 1, name: "Title 1"),
                TVShowDTO(id: 2, name: "Title 2"),
                TVShowDTO(id: 3, name: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.tvShows = expectedResult
        let expectedQuery = "some query"
        let expectedPage = 2

        let result = try await(publisher: tmdb.searchTVShowsPublisher(withQuery: expectedQuery, page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchTVShowsQuery, expectedQuery)
        XCTAssertNil(searchService.lastSearchTVShowsFirstAirDateYear)
        XCTAssertEqual(searchService.lastSearchTVShowsPage, expectedPage)
    }

    func testSearchTVShowsPublisherWithFirstAirDateYearPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableListDTO(
            page: 2,
            results: [
                TVShowDTO(id: 1, name: "Title 1"),
                TVShowDTO(id: 2, name: "Title 2"),
                TVShowDTO(id: 3, name: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.tvShows = expectedResult
        let expectedQuery = "some query"
        let expectedYear = 2020
        let expectedPage = 2

        let result = try await(
            publisher: tmdb.searchTVShowsPublisher(withQuery: expectedQuery, firstAirDateYear: expectedYear,
                                                   page: expectedPage),
            storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchTVShowsQuery, expectedQuery)
        XCTAssertEqual(searchService.lastSearchTVShowsFirstAirDateYear, expectedYear)
        XCTAssertEqual(searchService.lastSearchTVShowsPage, expectedPage)
    }

}

extension TMDbAPISearchTests {

    func testSearchPeoplePublisherReturnsPeople() throws {
        let expectedResult = PersonPageableListDTO(
            page: 2,
            results: [
                PersonDTO(id: 1, name: "Name 1"),
                PersonDTO(id: 2, name: "Name 2"),
                PersonDTO(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.people = expectedResult
        let expectedQuery = "some query"

        let result = try await(
            publisher: tmdb.searchPeoplePublisher(withQuery: expectedQuery), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchPeopleQuery, expectedQuery)
        XCTAssertNil(searchService.lastSearchPeoplePage)
    }

    func testSearchPeoplePublisherWithPageReturnsPeople() throws {
        let expectedResult = PersonPageableListDTO(
            page: 2,
            results: [
                PersonDTO(id: 1, name: "Name 1"),
                PersonDTO(id: 2, name: "Name 2"),
                PersonDTO(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        searchService.people = expectedResult
        let expectedQuery = "some query"
        let expectedPage = 2

        let result = try await(
            publisher: tmdb.searchPeoplePublisher(withQuery: expectedQuery, page: expectedPage), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(searchService.lastSearchPeopleQuery, expectedQuery)
        XCTAssertEqual(searchService.lastSearchPeoplePage, expectedPage)
    }

}
