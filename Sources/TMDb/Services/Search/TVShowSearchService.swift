import Foundation

/// A service to search for TV shows.
public protocol TVShowSearchService {

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

}

public extension TVShowSearchService {

    func searchTVShows(query: String, firstAirDateYear: Int? = nil,
                       page: Int? = nil) async throws -> TVShowPageableList {
        try await searchTVShows(query: query, firstAirDateYear: firstAirDateYear, page: page)
    }

}
