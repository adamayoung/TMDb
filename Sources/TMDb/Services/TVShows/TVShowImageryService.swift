import Foundation

/// A service to fetch images and videos for a TV show.
public protocol TVShowImageryService {

    /// Returns the images that belong to a TV show.
    ///
    /// [TMDb API - TV Shows: Images](https://developers.themoviedb.org/3/tv/get-tv-images)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of images for the matching TV show.
    func images(forTVShow tvShowID: TVShow.ID) async throws -> ImageCollection

    /// Returns the videos that belong to a TV show.
    ///
    /// [TMDb API - TV Shows: Videos](https://developers.themoviedb.org/3/tv/get-tv-videos)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of videos for the matching TV show.
    func videos(forTVShow tvShowID: TVShow.ID) async throws -> VideoCollection

}
