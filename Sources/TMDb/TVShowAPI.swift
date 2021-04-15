import Combine
import Foundation

public protocol TVShowAPI {

    /// Publishes the primary information about a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Details](https://developers.themoviedb.org/3/tv/get-tv-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the TV show.
    ///
    /// - Returns: A publisher with the matching TV show.
    func detailsPublisher(forTVShow id: TVShow.ID) -> AnyPublisher<TVShow, TMDbError>

    /// Publishes the cast and crew of a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Credits](https://developers.themoviedb.org/3/tv/get-tv-credits)
    ///
    /// - Parameter tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A publisher with show credits for the matching TV show.
    func creditsPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ShowCredits, TMDbError>

    /// Publishes the user reviews for a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Reviews](https://developers.themoviedb.org/3/tv/get-tv-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with reviews for the matching TV show as a pageable list.
    func reviewsPublisher(forTVShow tvShowID: TVShow.ID,
                          page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError>

    /// Publishes the images that belong to a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Images](https://developers.themoviedb.org/3/tv/get-tv-images)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A publisher with a collection of images for the matching TV show.
    func imagesPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError>

    /// Publishes the videos that belong to a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Videos](https://developers.themoviedb.org/3/tv/get-tv-videos)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A publisher with a collection of videos for the matching TV show.
    func videosPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError>

    /// Publishes a list of recommended TV shows for a TV show.
    ///
    /// - Note: [TMDb API - TV Shows: Recommendations](https://developers.themoviedb.org/3/tv/get-tv-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with recommended TV shows for the matching TV show as a pageable list.
    func recommendationsPublisher(forTVShow tvShowID: TVShow.ID,
                                  page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    /// Publishes a list of similar TV shows for a TV show.
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
    /// - Returns: A publisher with similar TV shows for the matching TV show as a pageable list.
    func tvShowsPublisher(similarToTVShow tvShowID: TVShow.ID,
                          page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    /// Publishes a list current popular TV shows.
    ///
    /// - Note: [TMDb API - TV: Popular](https://developers.themoviedb.org/3/tv/get-popular-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with current popular TV shows as a pageable list.
    func popularTVShowsPublisher(page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    /// Publishes the primary information about a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Details](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-details)
    ///
    /// - Parameters:
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A publisher with a season of the matching TV show..
    func detailsPublisher(forSeason seasonNumber: Int,
                          inTVShow tvShowID: TVShow.ID) -> AnyPublisher<TVShowSeason, TMDbError>

    /// Publishes the images that belong to a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Images](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-images)
    ///
    /// - Parameters:
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A publisher with a collection of images for the matching TV show's season.
    func imagesPublisher(forSeason seasonNumber: Int,
                         inTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError>

    /// Publishes the videos that belong to a TV show season.
    ///
    /// - Note: [TMDb API - TV Show Seasons: Videos](https://developers.themoviedb.org/3/tv-seasons/get-tv-season-videos)
    ///
    /// - Parameters:
    ///     - seasonNumber: The season number of a TV show.
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A publisher with a collection of videos for the matching TV show's season.
    func videosPublisher(forSeason seasonNumber: Int,
                         inTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError>

}

public extension TVShowAPI {

    func reviewsPublisher(forTVShow tvShowID: TVShow.ID,
                          page: Int? = nil) -> AnyPublisher<ReviewPageableList, TMDbError> {
        reviewsPublisher(forTVShow: tvShowID, page: page)
    }

    func recommendationsPublisher(forTVShow tvShowID: TVShow.ID,
                                  page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        recommendationsPublisher(forTVShow: tvShowID, page: page)
    }

    func tvShowsPublisher(similarToTVShow tvShowID: TVShow.ID,
                          page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        tvShowsPublisher(similarToTVShow: tvShowID, page: page)
    }

    func popularTVShowsPublisher(page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        popularTVShowsPublisher(page: page)
    }

}
