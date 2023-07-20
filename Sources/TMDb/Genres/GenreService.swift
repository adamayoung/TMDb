import Foundation

///
/// Provides an interface for obtaining movie and TV show genres from TMDb.
///
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public final class GenreService {

    private let apiClient: APIClient

    ///
    /// Creates a genre service object.
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
    /// Returns the list of official genres for movies.
    ///
    /// [TMDb API - Genres: Movies](https://developers.themoviedb.org/3/genres/get-movie-list)
    ///
    /// - Returns: A list of genres.
    ///
    public func movieGenres() async throws -> [Genre] {
        let genreList: GenreList = try await apiClient.get(endpoint: GenresEndpoint.movie)
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
        let genreList: GenreList = try await apiClient.get(endpoint: GenresEndpoint.tvShow)
        return genreList.genres
    }

}
