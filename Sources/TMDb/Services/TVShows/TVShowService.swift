import Foundation

#if canImport(Combine)
import Combine
#endif

/// Fetch details about TV shows.
public protocol TVShowService {

    /// Fetches the primary information about a TV show.
    ///
    /// [TMDb API - TV Shows: Details](https://developers.themoviedb.org/3/tv/get-tv-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the TV show.
    ///     - completion: Completion handler.
    ///     - result: The matching TV show.
    func fetchDetails(forTVShow id: TVShow.ID, completion: @escaping (_ result: Result<TVShow, TMDbError>) -> Void)

    /// Fetches the cast and crew of a TV show.
    ///
    /// [TMDb API - TV Shows: Credits](https://developers.themoviedb.org/3/tv/get-tv-credits)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - completion: Completion handler.
    ///     - result: Show credits for the matching TV show.
    func fetchCredits(forTVShow tvShowID: TVShow.ID,
                      completion: @escaping (_ result: Result<ShowCredits, TMDbError>) -> Void)

    /// Fetches the user reviews for a TV show.
    ///
    /// [TMDb API - TV Shows: Reviews](https://developers.themoviedb.org/3/tv/get-tv-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Reviews for the matching TV show as a pageable list.
    func fetchReviews(forTVShow tvShowID: TVShow.ID, page: Int?,
                      completion: @escaping (_ result: Result<ReviewPageableList, TMDbError>) -> Void)

    /// Fetches the images that belong to a TV show.
    ///
    /// [TMDb API - TV Shows: Images](https://developers.themoviedb.org/3/tv/get-tv-images)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - completion: Completion handler.
    ///     - result: A collection of images for the matching TV show.
    func fetchImages(forTVShow tvShowID: TVShow.ID,
                     completion: @escaping (_ result: Result<ImageCollection, TMDbError>) -> Void)

    /// Fetches the videos that belong to a TV show.
    ///
    /// [TMDb API - TV Shows: Videos](https://developers.themoviedb.org/3/tv/get-tv-videos)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - completion: Completion handler.
    ///     - result: A collection of videos for the matching TV show.
    func fetchVideos(forTVShow tvShowID: TVShow.ID,
                     completion: @escaping (_ result: Result<VideoCollection, TMDbError>) -> Void)

    /// Fetches a list of recommended TV shows for a TV show.
    ///
    /// [TMDb API - TV Shows: Recommendations](https://developers.themoviedb.org/3/tv/get-tv-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Recommended TV shows for the matching TV show as a pageable list.
    func fetchRecommendations(forTVShow tvShowID: TVShow.ID, page: Int?,
                              completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void)

    /// Fetches a list of similar TV shows for a TV show.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV: Similar](https://developers.themoviedb.org/3/tv/get-tv-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show for get similar TV shows for.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Similar TV shows for the matching TV show as a pageable list.
    func fetchSimilar(toTVShow tvShowID: TVShow.ID, page: Int?,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void)

    /// Fetches a list current popular TV shows.
    ///
    /// [TMDb API - TV: Popular](https://developers.themoviedb.org/3/tv/get-popular-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Current popular TV shows as a pageable list.
    func fetchPopular(page: Int?, completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void)

    #if canImport(Combine)
    /// Publishes the primary information about a TV show.
    ///
    /// [TMDb API - TV Shows: Details](https://developers.themoviedb.org/3/tv/get-tv-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the TV show.
    ///
    /// - Returns: A publisher with the matching TV show.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func detailsPublisher(forTVShow id: TVShow.ID) -> AnyPublisher<TVShow, TMDbError>

    /// Publishes the cast and crew of a TV show.
    ///
    /// [TMDb API - TV Shows: Credits](https://developers.themoviedb.org/3/tv/get-tv-credits)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A publisher with show credits for the matching TV show.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func creditsPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ShowCredits, TMDbError>

    /// Publishes the user reviews for a TV show.
    ///
    /// [TMDb API - TV Shows: Reviews](https://developers.themoviedb.org/3/tv/get-tv-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with reviews for the matching TV show as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func reviewsPublisher(forTVShow tvShowID: TVShow.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError>

    /// Publishes the images that belong to a TV show.
    ///
    /// [TMDb API - TV Shows: Images](https://developers.themoviedb.org/3/tv/get-tv-images)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A publisher with a collection of images for the matching TV show.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func imagesPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError>

    /// Publishes the videos that belong to a TV show.
    ///
    /// [TMDb API - TV Shows: Videos](https://developers.themoviedb.org/3/tv/get-tv-videos)
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///
    /// - Returns: A publisher with a collection of videos for the matching TV show.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func videosPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError>

    /// Publishes a list of recommended TV shows for a TV show.
    ///
    /// [TMDb API - TV Shows: Recommendations](https://developers.themoviedb.org/3/tv/get-tv-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with recommended TV shows for the matching TV show as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func recommendationsPublisher(forTVShow tvShowID: TVShow.ID,
                                  page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    /// Publishes a list of similar TV shows for a TV show.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV: Similar](https://developers.themoviedb.org/3/tv/get-tv-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - tvShowID: The identifier of the TV show for get similar TV shows for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with similar TV shows for the matching TV show as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func similarPublisher(toTVShow tvShowID: TVShow.ID, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    /// Publishes a list current popular TV shows.
    ///
    /// [TMDb API - TV: Popular](https://developers.themoviedb.org/3/tv/get-popular-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with current popular TV shows as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func popularPublisher(page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>
    #endif

}

public extension TVShowService {

    func fetchReviews(forTVShow tvShowID: TVShow.ID, page: Int? = nil,
                      completion: @escaping (_ result: Result<ReviewPageableList, TMDbError>) -> Void) {
        fetchReviews(forTVShow: tvShowID, page: page, completion: completion)
    }

    func fetchRecommendations(forTVShow tvShowID: TVShow.ID, page: Int? = nil,
                              completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void) {
        fetchRecommendations(forTVShow: tvShowID, page: page, completion: completion)
    }

    func fetchSimilar(toTVShow tvShowID: TVShow.ID, page: Int? = nil,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void) {
        fetchSimilar(toTVShow: tvShowID, page: page, completion: completion)
    }

    func fetchPopular(page: Int? = nil,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void) {
        fetchPopular(page: page, completion: completion)
    }

}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension TVShowService {

    func reviewsPublisher(forTVShow tvShowID: TVShow.ID,
                          page: Int? = nil) -> AnyPublisher<ReviewPageableList, TMDbError> {
        reviewsPublisher(forTVShow: tvShowID, page: page)
    }

    func recommendationsPublisher(forTVShow tvShowID: TVShow.ID,
                                  page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        recommendationsPublisher(forTVShow: tvShowID, page: page)
    }

    func similarPublisher(toTVShow tvShowID: TVShow.ID,
                          page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        similarPublisher(toTVShow: tvShowID, page: page)
    }

    func popularPublisher(page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        popularPublisher(page: page)
    }

}
#endif
