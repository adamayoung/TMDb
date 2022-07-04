import Foundation

/// A service to fetch credits for a movie.
public protocol MovieCreditsService {

    /// Returns the cast and crew of a movie.
    ///
    /// [TMDb API - Movie: Credits](https://developers.themoviedb.org/3/movies/get-movie-credits)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: Credits for the matching movie.
    func credits(forMovie movieID: Movie.ID) async throws -> ShowCredits

}
