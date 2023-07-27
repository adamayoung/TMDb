import Foundation
import os

///
/// Provides an interface for discovering movies and TV shows from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class DiscoverService {

    private static let logger = Logger(subsystem: Logger.tmdb, category: "DiscoverService")

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
        Self.logger.info("fetching movies")

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(
                endpoint: DiscoverEndpoint.movies(sortedBy: sortedBy, people: people, page: page)
            )
        } catch let error {
            Self.logger.error("failed fetching movies: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return movieList
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
        Self.logger.info("fetching TV shows")

        let tvShowList: TVShowPageableList
        do {
            tvShowList = try await apiClient.get(endpoint: DiscoverEndpoint.tvShows(sortedBy: sortedBy, page: page))
        } catch let error {
            Self.logger.error("failed fetching TV shows: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return tvShowList
    }

}
