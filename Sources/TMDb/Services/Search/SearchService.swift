import Foundation

#if canImport(Combine)
import Combine
#endif

/// Search for movies, TV shows and people.
public protocol SearchService {

    /// Fetches search results for movies, TV shows and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
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
    /// [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
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
    /// [TMDb API - Search: TV Shows](https://developers.themoviedb.org/3/search/search-tv-shows)
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
    /// [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
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
    /// [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
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
    /// [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
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
    /// [TMDb API - Search: TV Shows](https://developers.themoviedb.org/3/search/search-tv-shows)
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
    /// [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
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

    /// Returns search results for movies, TV shows and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Movies, TV shows and people matching the query.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func searchAll(query: String, page: Int?) async throws -> MediaPageableList

    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - year: The year to filter results for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Movies matching the query.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func searchMovies(query: String, year: Int?, page: Int?) async throws -> MoviePageableList

    /// Returns search results for TV shows.
    ///
    /// [TMDb API - Search: TV Shows](https://developers.themoviedb.org/3/search/search-tv-shows)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - firstAirDateYear: The year of first air date to filter results for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: TV shows matching the query.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func searchTVShows(query: String, firstAirDateYear: Int?, page: Int?) async throws -> TVShowPageableList

    /// Returns search results for people.
    ///
    /// [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - query: A text query to search for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: People matching the query.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func searchPeople(query: String, page: Int?) async throws -> PersonPageableList

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

@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension SearchService {

    func searchAll(query: String, page: Int? = nil) async throws -> MediaPageableList {
        try await searchAll(query: query, page: page)
    }

    func searchMovies(query: String, year: Int? = nil, page: Int? = nil) async throws -> MoviePageableList {
        try await searchMovies(query: query, year: year, page: page)
    }

    func searchTVShows(query: String, firstAirDateYear: Int? = nil,
                       page: Int? = nil) async throws -> TVShowPageableList {
        try await searchTVShows(query: query, firstAirDateYear: firstAirDateYear, page: page)
    }

    func searchPeople(query: String, page: Int? = nil) async throws -> PersonPageableList {
        try await searchPeople(query: query, page: page)
    }

}
