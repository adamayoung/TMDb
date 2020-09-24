import Combine
@testable import TMDb
import XCTest

final class MockSearchService: SearchService {

    var media: MediaPageableListDTO?
    private(set) var lastSearchAllQuery: String?
    private(set) var lastSearchAllPage: Int?
    var movies: MoviePageableListDTO?
    private(set) var lastSearchMoviesQuery: String?
    private(set) var lastSearchMoviesYear: Int?
    private(set) var lastSearchMoviesPage: Int?
    var tvShows: TVShowPageableListDTO?
    private(set) var lastSearchTVShowsQuery: String?
    private(set) var lastSearchTVShowsFirstAirDateYear: Int?
    private(set) var lastSearchTVShowsPage: Int?
    var people: PersonPageableListDTO?
    private(set) var lastSearchPeopleQuery: String?
    private(set) var lastSearchPeoplePage: Int?

    func searchAll(query: String, page: Int?) -> AnyPublisher<MediaPageableListDTO, TMDbError> {
        lastSearchAllQuery = query
        lastSearchAllPage = page

        guard let media = media else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(media)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func searchMovies(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        lastSearchMoviesQuery = query
        lastSearchMoviesYear = year
        lastSearchMoviesPage = page

        guard let movies = movies else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movies)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func searchTVShows(query: String, firstAirDateYear: Int?,
                       page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        lastSearchTVShowsQuery = query
        lastSearchTVShowsFirstAirDateYear = firstAirDateYear
        lastSearchTVShowsPage = page

        guard let tvShows = tvShows else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShows)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func searchPeople(query: String, page: Int?) -> AnyPublisher<PersonPageableListDTO, TMDbError> {
        lastSearchPeopleQuery = query
        lastSearchPeoplePage = page

        guard let people = people else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(people)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
