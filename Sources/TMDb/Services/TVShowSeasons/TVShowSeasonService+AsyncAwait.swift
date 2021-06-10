import Foundation

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension TVShowSeasonService {

    /// Returns the primary information about a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Details](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-details)
    ///
    /// - Parameters:
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A season of the matching TV show.
    func details(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowSeason {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchDetails(forSeason: seasonNumber, inTVShow: tvShowID, completion: continuation.resume(with:))
        }
    }

    /// Returns the images that belong to a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Images](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-images)
    ///
    /// - Parameters:
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of images for the matching TV show's season.
    func images(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchImages(forSeason: seasonNumber, inTVShow: tvShowID, completion: continuation.resume(with:))
        }
    }

    /// Returns the videos that belong to a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Videos](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-videos)
    ///
    /// - Parameters:
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of videos for the matching TV show's season.
    func videos(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchVideos(forSeason: seasonNumber, inTVShow: tvShowID, completion: continuation.resume(with:))
        }
    }

}
#endif
