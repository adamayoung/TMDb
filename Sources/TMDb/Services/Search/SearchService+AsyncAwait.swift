import Foundation

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
