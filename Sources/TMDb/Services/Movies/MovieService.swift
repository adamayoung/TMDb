import Foundation

#if canImport(Combine)
import Combine
#endif

/// Movie interface.
public protocol MovieService {

    /// Publishes the primary information about a movie.
    ///
    /// - Note: [TMDb API - Movie: Details](https://developers.themoviedb.org/3/movies/get-movie-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the movie.
    ///     - completion: Completion handler.
    ///     - result: The matching movie.
    func fetchDetails(forMovie id: Movie.ID, completion: @escaping (_ result: Result<Movie, TMDbError>) -> Void)

    /// Publishes the cast and crew of a movie.
    ///
    /// - Note: [TMDb API - Movie: Credits](https://developers.themoviedb.org/3/movies/get-movie-credits)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///     - completion: Completion handler.
    ///     - result: Credits for the matching movie.
    func fetchCredits(forMovie movieID: Movie.ID,
                      completion: @escaping (_ result: Result<ShowCredits, TMDbError>) -> Void)

    /// Publishes the user reviews for a movie.
    ///
    /// - Note: [TMDb API - Movie: Reviews](https://developers.themoviedb.org/3/movies/get-movie-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Reviews for the matching movie as a pageable list.
    func fetchReviews(forMovie movieID: Movie.ID, page: Int?,
                      completion: @escaping (_ result: Result<ReviewPageableList, TMDbError>) -> Void)

    /// Publishes the images that belong to a movie.
    ///
    /// - Note: [TMDb API - Movie: Images](https://developers.themoviedb.org/3/movies/get-movie-images)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///     - completion: Completion handler.
    ///     - result: Collection of images for the matching movie.
    func fetchImages(forMovie movieID: Movie.ID,
                     completion: @escaping (_ result: Result<ImageCollection, TMDbError>) -> Void)

    /// Publishes the videos that have been added to a movie.
    ///
    /// - Note: [TMDb API - Movie: Videos](https://developers.themoviedb.org/3/movies/get-movie-videos)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///     - completion: Completion handler.
    ///     - result: Collection of videos for the matching movie.
    func fetchVideos(forMovie movieID: Movie.ID,
                     completion: @escaping (_ result: Result<VideoCollection, TMDbError>) -> Void)

    /// Publishes a list of recommended movies for a movie.
    ///
    /// - Note: [TMDb API - Movie: Recommendations](https://developers.themoviedb.org/3/movies/get-movie-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie for get recommendations for.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Recommended movies for the matching movie as a pageable list.
    func fetchRecommendations(forMovie movieID: Movie.ID, page: Int?,
                              completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void)

    /// Publishes a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// - Note: [TMDb API - Movie: Similar](https://developers.themoviedb.org/3/movies/get-similar-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie for get similar movies for.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Similar movies for the matching movie as a pageable list.
    func fetchSimilar(toMovie movieID: Movie.ID, page: Int?,
                      completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void)

    /// Publishes a list of current popular movies.
    ///
    /// - Note: [TMDb API - Movie: Popular](https://developers.themoviedb.org/3/movies/get-popular-movies)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Current popular movies as a pageable list.
    func fetchPopular(page: Int?, completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void)

    #if canImport(Combine)
    /// Publishes the primary information about a movie.
    ///
    /// - Note: [TMDb API - Movie: Details](https://developers.themoviedb.org/3/movies/get-movie-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the movie.
    ///
    /// - Returns: A publisher with the matching movie.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func detailsPublisher(forMovie id: Movie.ID) -> AnyPublisher<Movie, TMDbError>

    /// Publishes the cast and crew of a movie.
    ///
    /// - Note: [TMDb API - Movie: Credits](https://developers.themoviedb.org/3/movies/get-movie-credits)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: A publisher with show credits for the matching movie.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func creditsPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<ShowCredits, TMDbError>

    /// Publishes the user reviews for a movie.
    ///
    /// - Note: [TMDb API - Movie: Reviews](https://developers.themoviedb.org/3/movies/get-movie-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with reviews for the matching movie as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func reviewsPublisher(forMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError>

    /// Publishes the images that belong to a movie.
    ///
    /// - Note: [TMDb API - Movie: Images](https://developers.themoviedb.org/3/movies/get-movie-images)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: A publisher with a collection of images for the matching movie.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func imagesPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<ImageCollection, TMDbError>

    /// Publishes the videos that have been added to a movie.
    ///
    /// - Note: [TMDb API - Movie: Videos](https://developers.themoviedb.org/3/movies/get-movie-videos)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: A publisher with a collection of videos for the matching movie.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func videosPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<VideoCollection, TMDbError>

    /// Publishes a list of recommended movies for a movie.
    ///
    /// - Note: [TMDb API - Movie: Recommendations](https://developers.themoviedb.org/3/movies/get-movie-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie for get recommendations for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with recommended movies for the matching movie as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func recommendationsPublisher(forMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    /// Publishes a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// - Note: [TMDb API - Movie: Similar](https://developers.themoviedb.org/3/movies/get-similar-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie for get similar movies for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with similar movies for the matching movie as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func similarPublisher(toMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    /// Publishes a list of current popular movies.
    ///
    /// - Note: [TMDb API - Movie: Popular](https://developers.themoviedb.org/3/movies/get-popular-movies)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with current popular movies as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func popularPublisher(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>
    #endif

}

public extension MovieService {

    func fetchReviews(forMovie movieID: Movie.ID, page: Int? = nil,
                      completion: @escaping (Result<ReviewPageableList, TMDbError>) -> Void) {
        fetchReviews(forMovie: movieID, page: page, completion: completion)
    }

    func fetchRecommendations(forMovie movieID: Movie.ID, page: Int? = nil,
                              completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        fetchRecommendations(forMovie: movieID, page: page, completion: completion)
    }

    func fetchSimilar(toMovie movieID: Movie.ID, page: Int? = nil,
                      completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        fetchSimilar(toMovie: movieID, page: page, completion: completion)
    }

    func fetchPopular(page: Int? = nil, completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        fetchPopular(page: page, completion: completion)
    }

}

#if canImport(Combine)
public extension MovieService {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func reviewsPublisher(forMovie movieID: Movie.ID, page: Int? = nil) -> AnyPublisher<ReviewPageableList, TMDbError> {
        reviewsPublisher(forMovie: movieID, page: page)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func recommendationsPublisher(forMovie movieID: Movie.ID,
                                  page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        recommendationsPublisher(forMovie: movieID, page: page)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func similarPublisher(toMovie movieID: Movie.ID, page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        similarPublisher(toMovie: movieID, page: page)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func popularPublisher(page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        popularPublisher(page: page)
    }

}
#endif
