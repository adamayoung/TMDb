import Foundation

///
/// Provides an interface for discovering movies and TV shows from TMDb.
///
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public final class DiscoverService {

    private let apiClient: APIClient

    ///
    /// Creates a discover service object.
    ///
    /// - Parameters:
    ///    - config: TMDb configuration setting.
    ///
    public convenience init(config: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(apiKey: config.apiKey)
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movies](https://developers.themoviedb.org/3/discover/movie-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - people: A list of Person identifiers which to return only movies they have appeared in.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Matching movies as a pageable list.
    /// 
    public func movies(sortedBy: MovieSort? = nil, withPeople people: [Person.ID]? = nil,
                       page: Int? = nil) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: DiscoverEndpoint.movies(sortedBy: sortedBy, people: people, page: page))
    }

    ///
    /// Returns TV shows to be discovered.
    ///
    /// [TMDb API - Discover: TV Shows](https://developers.themoviedb.org/3/discover/tv-discover)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Matching TV shows as a pageable list.
    ///
    public func tvShows(sortedBy: TVShowSort? = nil, page: Int? = nil) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: DiscoverEndpoint.tvShows(sortedBy: sortedBy, page: page))
    }

}
