import Foundation

#if canImport(Combine)
import Combine
#endif

public protocol SearchService {

    /// Fetches search results for movies, TV shows and people based on a query.
    ///
    /// - Note: [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Movies, TV shows and people matching the query.
    func searchAll(query: String, page: Int?,
                   completion: @escaping (_ result: Result<MediaPageableList, TMDbError>) -> Void)

    /// Fetches search results for movies.
    ///
    /// - Note: [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - year: The year to filter results for.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Movies matching the query.
    func searchMovies(query: String, year: Int?, page: Int?,
                      completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void)

    /// Fetches search results for TV shows.
    ///
    /// - Note: [TMDb API - Search: TV Shows](https://developers.themoviedb.org/3/search/search-tv-shows)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - firstAirDateYear: The year of first air date to filter results for.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: TV shows matching the query.
    func searchTVShows(query: String, firstAirDateYear: Int?, page: Int?,
                       completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void)

    /// Fetches search results for people.
    ///
    /// - Note: [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: People matching the query.
    func searchPeople(query: String, page: Int?,
                      completion: @escaping (_ result: Result<PersonPageableList, TMDbError>) -> Void)

    #if canImport(Combine)
    /// Publishes search results for movies, TV shows and people based on a query.
    ///
    /// - Note: [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with movies, TV shows and people matching the query.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func searchAllPublisher(query: String, page: Int?) -> AnyPublisher<MediaPageableList, TMDbError>

    /// Publishes search results for movies.
    ///
    /// - Note: [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - year: The year to filter results for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with movies matching the query.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func searchMoviesPublisher(query: String, year: Int?, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    /// Publishes search results for TV shows.
    ///
    /// - Note: [TMDb API - Search: TV Shows](https://developers.themoviedb.org/3/search/search-tv-shows)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - firstAirDateYear: The year of first air date to filter results for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with TV shows matching the query.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func searchTVShowsPublisher(query: String, firstAirDateYear: Int?,
                                page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    /// Publishes search results for people.
    ///
    /// - Note: [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with people matching the query.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func searchPeoplePublisher(query: String, page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>
    #endif

}

public extension SearchService {

    func searchAll(query: String, page: Int? = nil,
                   completion: @escaping (_ result: Result<MediaPageableList, TMDbError>) -> Void) {
        searchAll(query: query, page: page, completion: completion)
    }

    func searchMovies(query: String, year: Int? = nil, page: Int? = nil,
                      completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void) {
        searchMovies(query: query, year: year, page: page, completion: completion)
    }

    func searchTVShows(query: String, firstAirDateYear: Int? = nil, page: Int? = nil,
                       completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void) {
        searchTVShows(query: query, firstAirDateYear: firstAirDateYear, page: page, completion: completion)

    }

    func searchPeople(query: String, page: Int? = nil,
                      completion: @escaping (_ result: Result<PersonPageableList, TMDbError>) -> Void) {
        searchPeople(query: query, page: page, completion: completion)
    }

}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension SearchService {

    func searchAllPublisher(query: String, page: Int? = nil) -> AnyPublisher<MediaPageableList, TMDbError> {
        searchAllPublisher(query: query, page: page)
    }

    func searchMoviesPublisher(query: String, year: Int? = nil,
                               page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        searchMoviesPublisher(query: query, year: year, page: page)
    }

    func searchTVShowsPublisher(query: String, firstAirDateYear: Int? = nil,
                                page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        searchTVShowsPublisher(query: query, firstAirDateYear: firstAirDateYear, page: page)
    }

    func searchPeoplePublisher(query: String, page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        searchPeoplePublisher(query: query, page: page)
    }

}
#endif

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension SearchService {

    /// Returns search results for movies, TV shows and people based on a query.
    ///
    /// - Note: [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Movies, TV shows and people matching the query.
    func searchAll(query: String, page: Int? = nil) async throws -> MediaPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.searchAll(query: query, page: page, completion: continuation.resume(with:))
        }
    }

    /// Fetches search results for movies.
    ///
    /// - Note: [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - year: The year to filter results for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Movies matching the query.
    func searchMovies(query: String, year: Int? = nil, page: Int? = nil) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.searchMovies(query: query, year: year, page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns search results for TV shows.
    ///
    /// - Note: [TMDb API - Search: TV Shows](https://developers.themoviedb.org/3/search/search-tv-shows)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - firstAirDateYear: The year of first air date to filter results for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: TV shows matching the query.
    func searchTVShows(query: String, firstAirDateYear: Int? = nil,
                       page: Int? = nil) async throws -> TVShowPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.searchTVShows(query: query, firstAirDateYear: firstAirDateYear, page: page,
                               completion: continuation.resume(with:))
        }
    }

    /// Returns search results for people.
    ///
    /// - Note: [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: People matching the query.
    func searchPeople(query: String, page: Int? = nil) async throws -> PersonPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.searchPeople(query: query, page: page, completion: continuation.resume(with:))
        }
    }

}
#endif
