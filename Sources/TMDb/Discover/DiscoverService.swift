import Foundation

///
/// Provides an interface for discovering movies and TV shows from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class DiscoverService {

    private let apiClient: APIClient

    ///
    /// Creates a discover service object.
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
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - people: A list of Person identifiers which to return only movies they have appeared in.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    /// 
    public func movies(sortedBy: MovieSort? = nil, withPeople people: [Person.ID]? = nil,
                       page: Int? = nil) async throws -> MoviePageableList {
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(
                endpoint: DiscoverEndpoint.movies(sortedBy: sortedBy, people: people, page: page)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    ///
    /// Returns TV shows to be discovered.
    ///
    /// [TMDb API - Discover: TV](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV shows as a pageable list.
    ///
    public func tvShows(sortedBy: TVShowSort? = nil, page: Int? = nil) async throws -> TVShowPageableList {
        let tvShowList: TVShowPageableList
        do {
            tvShowList = try await apiClient.get(endpoint: DiscoverEndpoint.tvShows(sortedBy: sortedBy, page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvShowList
    }

}
