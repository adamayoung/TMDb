import Foundation

#if canImport(Combine)
import Combine
#endif

/// Discover movies by different types of data like average rating, number of votes, genres and certifications.
public protocol DiscoverService {

    /// Fetches movies to be discovered.
    ///
    /// [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - people: A list of Person identifiers which to return only movies they have appeared in.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Matching movies as a pageable list.
    func fetchMovies(sortedBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?,
                     completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void)

    /// Fetches TV shows to be discovered.
    ///
    /// [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Matching TV shows as a pageable list.
    func fetchTVShows(sortedBy: TVShowSort?, page: Int?,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void)

#if canImport(Combine)
    /// Publishes movies to be discovered.
    ///
    /// [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - people: A list of Person identifiers which to return only movies they have appeared in.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with the matching movies as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func moviesPublisher(sortedBy: MovieSort?, withPeople people: [Person.ID]?,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    /// Publishes TV shows to be discovered.
    ///
    /// [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with the matching TV shows as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowsPublisher(sortedBy: TVShowSort?, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>
#endif

    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - people: A list of Person identifiers which to return only movies they have appeared in.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Matching movies as a pageable list.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func movies(sortedBy: MovieSort?, withPeople people: [Person.ID]?, page: Int?) async throws -> MoviePageableList

    /// Returns TV shows to be discovered.
    ///
    /// [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - sortedBy: How results should be sorted.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Matching TV shows as a pageable list.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func tvShows(sortedBy: TVShowSort?, page: Int?) async throws -> TVShowPageableList

}

public extension DiscoverService {

    func fetchMovies(sortedBy: MovieSort? = nil, withPeople people: [Person.ID]? = nil, page: Int? = nil,
                     completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void) {
        fetchMovies(sortedBy: sortedBy, withPeople: people, page: page, completion: completion)
    }

    func fetchTVShows(sortedBy: TVShowSort? = nil, page: Int? = nil,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void) {
        fetchTVShows(sortedBy: sortedBy, page: page, completion: completion)
    }

}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension DiscoverService {

    func moviesPublisher(sortedBy: MovieSort? = nil, withPeople people: [Person.ID]? = nil,
                         page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        moviesPublisher(sortedBy: sortedBy, withPeople: people, page: page)
    }

    func tvShowsPublisher(sortedBy: TVShowSort? = nil,
                          page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        tvShowsPublisher(sortedBy: sortedBy, page: page)
    }

}
#endif

@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension DiscoverService {

    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func movies(sortedBy: MovieSort? = nil, withPeople people: [Person.ID]? = nil,
                page: Int? = nil) async throws -> MoviePageableList {
        try await movies(sortedBy: sortedBy, withPeople: people, page: page)
    }

    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func tvShows(sortedBy: TVShowSort? = nil, page: Int? = nil) async throws -> TVShowPageableList {
        try await tvShows(sortedBy: sortedBy, page: page)
    }

}
