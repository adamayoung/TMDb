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
    func discoverMoviesPublisher(sortBy: MovieSortBy?, withPeople: [PersonDTO.ID]?,
                                 page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

    /// Publishes TV shows to be discovered.
    ///
    /// - Note: [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Parameters:
    ///     - sortBy: How results should be sorted.
    ///     - page: The page of results to return. (minimum: `1`, maximum: `1000`)
    ///
    /// - Returns: A publisher with the matching TV shows as a pageable list.
    func discoverTVShowsPublisher(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError>

}

public extension DiscoveryAPI {

    func discoverMoviesPublisher(sortBy: MovieSortBy? = .default, withPeople: [PersonDTO.ID]? = nil,
                                 page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        discoverMoviesPublisher(sortBy: sortBy, withPeople: withPeople, page: page)
    }

    func discoverTVShowsPublisher(sortBy: TVShowSortBy? = nil,
                                  page: Int? = nil) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        discoverTVShowsPublisher(sortBy: sortBy, page: page)

    }

}
