import Foundation

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension TVShowService {

    /// Returns the primary information about a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Details](https://developers.themoviedb.org/3/tv/get-tv-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the TV show.
    ///
    /// - Returns: The matching TV show.
    func details(forTVShow id: TVShow.ID) async throws -> TVShow {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchDetails(forTVShow: id, completion: continuation.resume(with:))
        }
    }

    /// Returns the cast and crew of a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Credits](https://developers.themoviedb.org/3/tv/get-tv-credits)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: Show credits for the matching TV show.
    func credits(forTVShow tvShowID: TVShow.ID) async throws -> ShowCredits {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchCredits(forTVShow: tvShowID, completion: continuation.resume(with:))
        }
    }

    /// Returns the user reviews for a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Reviews](https://developers.themoviedb.org/3/tv/get-tv-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Reviews for the matching TV show as a pageable list.
    func reviews(forTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> ReviewPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchReviews(forTVShow: tvShowID, page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns the images that belong to a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Images](https://developers.themoviedb.org/3/tv/get-tv-images)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of images for the matching TV show.
    func images(forTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchImages(forTVShow: tvShowID, completion: continuation.resume(with:))
        }
    }

    /// Returns the videos that belong to a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Videos](https://developers.themoviedb.org/3/tv/get-tv-videos)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A collection of videos for the matching TV show.
    func videos(forTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchVideos(forTVShow: tvShowID, completion: continuation.resume(with:))
        }
    }

    /// Returns a list of recommended TV shows for a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Recommendations](https://developers.themoviedb.org/3/tv/get-tv-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Recommended TV shows for the matching TV show as a pageable list.
    func recommendations(forTVShow tvShowID: TVShow.ID, page: Int? = nil) async throws -> TVShowPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchRecommendations(forTVShow: tvShowID, page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns a list of similar TV shows for a TV show.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// - Note: [TMDb API - TV: Similar](https://developers.themoviedb.org/3/tv/get-tv-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show for get similar TV shows for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Similar TV shows for the matching TV show as a pageable list.
    func similar(toTVShow tvShowID: TVShow.ID, page: Int?) async throws -> TVShowPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchSimilar(toTVShow: tvShowID, page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns a list current popular TV shows.
    ///
    /// - Note: [TMDb API - TV: Popular](https://developers.themoviedb.org/3/tv/get-popular-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular TV shows as a pageable list.
    func popular(page: Int?) async throws -> TVShowPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchPopular(page: page, completion: continuation.resume(with:))
        }
    }

}
#endif
