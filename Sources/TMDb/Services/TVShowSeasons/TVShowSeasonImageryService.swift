import Foundation

/// A service to fetch image and videos for a TV show season.
public protocol TVShowSeasonImageryService {

    /// Returns the images that belong to a TV show season.
    ///
    /// [TMDb API - TV Show Seasons: Images](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-images)
    ///
    /// - Parameters:
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of images for the matching TV show's season.
    func images(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> ImageCollection

    /// Returns the videos that belong to a TV show season.
    ///
    /// [TMDb API - TV Show Seasons: Videos](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-videos)
    ///
    /// - Parameters:
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of videos for the matching TV show's season.
    func videos(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> VideoCollection

}
