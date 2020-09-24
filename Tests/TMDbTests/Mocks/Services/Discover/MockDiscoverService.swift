import Combine
@testable import TMDb
import XCTest

final class MockDiscoverService: DiscoverService {

    var movies: MoviePageableListDTO?
    private(set) var lastMoviesSortBy: MovieSortBy?
    private(set) var lastMoviesWithPeople: [PersonDTO.ID]?
    private(set) var lastMoviesPage: Int?
    var tvShows: TVShowPageableListDTO?
    private(set) var lastTVShowsSortBy: TVShowSortBy?
    private(set) var lastTVShowsPage: Int?

    func fetchMovies(sortBy: MovieSortBy?, withPeople: [PersonDTO.ID]?,
                     page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        lastMoviesSortBy = sortBy
        lastMoviesWithPeople = withPeople
        lastMoviesPage = page

        guard let movies = movies else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movies)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchTVShows(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        lastTVShowsSortBy = sortBy
        lastTVShowsPage = page

        guard let tvShows = tvShows else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShows)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
