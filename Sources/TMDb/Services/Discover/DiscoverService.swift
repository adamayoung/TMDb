import Foundation

#if canImport(Combine)
import Combine
#endif

/// Discovery interface.
public protocol DiscoverService {

    /// Fetches movies to be discovered.
    ///
    /// - Note: [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortBy: How results should be sorted.
    ///     - people: A list of Person identifiers which to return only movies they have appeared in.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Matching movies as a pageable list.
    func fetchMovies(sortBy: MovieSortBy?, withPeople people: [Person.ID]?, page: Int?,
                     completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void)

    /// Fetches TV shows to be discovered.
    ///
    /// - Note: [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortBy: How results should be sorted.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Matching TV shows as a pageable list.
    func fetchTVShows(sortBy: TVShowSortBy?, page: Int?,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void)

    #if canImport(Combine)
    /// Publishes movies to be discovered.
    ///
    /// - Note: [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortBy: How results should be sorted.
    ///     - people: A list of Person identifiers which to return only movies they have appeared in.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with the matching movies as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func moviesPublisher(sortBy: MovieSortBy?, withPeople people: [Person.ID]?,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    /// Publishes TV shows to be discovered.
    ///
    /// - Note: [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortBy: How results should be sorted.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with the matching TV shows as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowsPublisher(sortBy: TVShowSortBy?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>
    #endif

}

public extension DiscoverService {

    func fetchMovies(sortBy: MovieSortBy? = .default, withPeople people: [Person.ID]? = nil, page: Int? = nil,
                     completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void) {
        fetchMovies(sortBy: sortBy, withPeople: people, page: page, completion: completion)
    }

    func fetchTVShows(sortBy: TVShowSortBy? = .default, page: Int? = nil,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void) {
        fetchTVShows(sortBy: sortBy, page: page, completion: completion)
    }

}

#if canImport(Combine)
public extension DiscoverService {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func moviesPublisher(sortBy: MovieSortBy? = .default, withPeople people: [Person.ID]? = nil,
                         page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        moviesPublisher(sortBy: sortBy, withPeople: people, page: page)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowsPublisher(sortBy: TVShowSortBy? = .default,
                          page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        tvShowsPublisher(sortBy: sortBy, page: page)
    }

}
#endif
