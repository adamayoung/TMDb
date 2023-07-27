import Foundation
import os

///
/// Provides an interface for obtaining movie and TV show genres from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class GenreService {

    private static let logger = Logger(subsystem: Logger.tmdb, category: "GenreService")

    private let apiClient: APIClient

    ///
    /// Creates a genre service object.
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
    /// Returns the list of official genres for movies.
    ///
    /// [TMDb API - Genres: Movies](https://developers.themoviedb.org/3/genres/get-movie-list)
    ///
    /// - Returns: A list of genres.
    ///
    public func movieGenres() async throws -> [Genre] {
        Self.logger.info("fetching movie genres")

        let genreList: GenreList
        do {
            genreList = try await apiClient.get(endpoint: GenresEndpoint.movie)
        } catch let error {
            Self.logger.error("failed fetching movie genres: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return genreList.genres
    }

    ///
    /// Returns the list of official genres for TV shows.
    ///
    /// [TMDb API - Genres: Movies](https://developers.themoviedb.org/3/genres/get-tv-list)
    ///
    /// - Returns: A list of genres.
    /// 
    public func tvShowGenres() async throws -> [Genre] {
        Self.logger.info("fetching TV show genres")

        let genreList: GenreList
        do {
            genreList = try await apiClient.get(endpoint: GenresEndpoint.tvShow)
        } catch let error {
            Self.logger.error("failed fetching TV show genres: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return genreList.genres
    }

}
