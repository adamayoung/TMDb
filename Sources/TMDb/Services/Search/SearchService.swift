import Foundation

/// Search for movies, TV shows and people.
public protocol SearchService {

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
    func searchPeople(query: String, page: Int?) async throws -> PersonPageableList

}

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
