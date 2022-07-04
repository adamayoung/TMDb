import Foundation

/// A service to fetch images and videos for a movie.
public protocol MovieImageryService {

    /// Returns the images that belong to a movie.
    ///
    /// [TMDb API - Movie: Images](https://developers.themoviedb.org/3/movies/get-movie-images)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: Collection of images for the matching movie.
    func images(forMovie movieID: Movie.ID) async throws -> ImageCollection

    /// Returns the videos that have been added to a movie.
    ///
    /// [TMDb API - Movie: Videos](https://developers.themoviedb.org/3/movies/get-movie-videos)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: Collection of videos for the matching movie.
    func videos(forMovie movieID: Movie.ID) async throws -> VideoCollection

}
