import Combine
import Foundation

/// Discovery API interface.
public protocol DiscoveryAPI {

    /// Publishes movies to be discovered.
    ///
    /// - Note: [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Parameters:
    ///     - sortBy: How results should be sorted.
    ///     - withPeople: A list of Person identifiers which to return only movies they have appeared in.
    ///     - page: The page of results to return. (minimum: `1`, maximum: `1000`)
    ///
    /// - Returns: A publisher with the matching movies as a pageable list.
    func discoverMoviesPublisher(sortBy: MovieSortBy?, withPeople: [Person.ID]?,
                                 page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    /// Publishes TV shows to be discovered.
    ///
    /// - Note: [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Parameters:
    ///     - sortBy: How results should be sorted.
    ///     - page: The page of results to return. (minimum: `1`, maximum: `1000`)
    ///
    /// - Returns: A publisher with the matching TV shows as a pageable list.
    func discoverTVShowsPublisher(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

}

public extension DiscoveryAPI {

    func discoverMoviesPublisher(sortBy: MovieSortBy? = .default, withPeople: [Person.ID]? = nil,
                                 page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        discoverMoviesPublisher(sortBy: sortBy, withPeople: withPeople, page: page)
    }

    func discoverTVShowsPublisher(sortBy: TVShowSortBy? = .default,
                                  page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        discoverTVShowsPublisher(sortBy: sortBy, page: page)

    }

}
