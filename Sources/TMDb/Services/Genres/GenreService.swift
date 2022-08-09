import Foundation

/// A service to fetch the official genres for Movies and TV Shows.
public protocol GenreService {

    /// Returns the list of official genres for movies.
    ///
    /// [TMDb API - Genres: Movies](https://developers.themoviedb.org/3/genres/get-movie-list)
    ///
    /// - Returns: A list of genres.
    func movieGenres() async throws -> [Genre]

    /// Returns the list of official genres for TV shows.
    ///
    /// [TMDb API - Genres: Movies](https://developers.themoviedb.org/3/genres/get-tv-list)
    ///
    /// - Returns: A list of genres.
    func tvShowGenres() async throws -> [Genre]

}
