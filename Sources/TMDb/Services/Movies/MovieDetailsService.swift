import Foundation

/// A service to fetch details of a movie.
public protocol MovieDetailsService {

    /// Returns the primary information about a movie.
    ///
    /// [TMDb API - Movie: Details](https://developers.themoviedb.org/3/movies/get-movie-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the movie.
    ///
    /// - Returns: The matching movie.
    func details(forMovie id: Movie.ID) async throws -> Movie

}
