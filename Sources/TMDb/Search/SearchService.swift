import Foundation

///
/// Provides an interface for searching content from TMDb..
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class SearchService {

    private let apiClient: APIClient

    ///
    /// Creates a search service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns search results for movies, TV shows and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developers.themoviedb.org/3/search/multi-search)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Movies, TV shows and people matching the query.
    /// 
    public func searchAll(query: String, page: Int? = nil) async throws -> MediaPageableList {
        try await apiClient.get(endpoint: SearchEndpoint.multi(query: query, page: page))
    }

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developers.themoviedb.org/3/search/search-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - year: The year to filter results for.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Movies matching the query.
    ///
    public func searchMovies(query: String, year: Int? = nil, page: Int? = nil) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: SearchEndpoint.movies(query: query, year: year, page: page))
    }

    ///
    /// Returns search results for TV shows.
    ///
    /// [TMDb API - Search: TV Shows](https://developers.themoviedb.org/3/search/search-tv-shows)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - firstAirDateYear: The year of first air date to filter results for.
    ///    - page: The page of results to return.
    ///
    /// - Returns: TV shows matching the query.
    ///
    public func searchTVShows(query: String, firstAirDateYear: Int? = nil,
                              page: Int? = nil) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: SearchEndpoint.tvShows(query: query, firstAirDateYear: firstAirDateYear,
                                                                 page: page))
    }

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: People](https://developers.themoviedb.org/3/search/search-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Returns: People matching the query.
    ///
    public func searchPeople(query: String, page: Int? = nil) async throws -> PersonPageableList {
        try await apiClient.get(endpoint: SearchEndpoint.people(query: query, page: page))
    }

}
