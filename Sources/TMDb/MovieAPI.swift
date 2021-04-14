import Combine
import Foundation

/// Movie API interface.
public protocol MovieAPI {

    /// Publishes the primary information about a movie.
    ///
    /// - Note: [TMDb API - Movie: Details](https://developers.themoviedb.org/3/movies/get-movie-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the movie.
    ///
    /// - Returns: A publisher with the matching movie.
    func detailsPublisher(forMovie id: MovieDTO.ID) -> AnyPublisher<MovieDTO, TMDbError>

    /// Publishes the cast and crew of a movie.
    ///
    /// - Note: [TMDb API - Movie: Credits](https://developers.themoviedb.org/3/movies/get-movie-credits)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: A publisher with show credits for the matching movie.
    func creditsPublisher(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ShowCreditsDTO, TMDbError>

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
    func reviewsPublisher(forMovie movieID: MovieDTO.ID, page: Int?) -> AnyPublisher<ReviewPageableListDTO, TMDbError>

    /// Publishes the images that belong to a movie.
    ///
    /// - Note: [TMDb API - Movie: Images](https://developers.themoviedb.org/3/movies/get-movie-images)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: A publisher with a collection of images for the matching movie.
    func imagesPublisher(forMovie movieID: MovieDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError>

    /// Publishes the videos that have been added to a movie.
    ///
    /// - Note: [TMDb API - Movie: Videos](https://developers.themoviedb.org/3/movies/get-movie-videos)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: A publisher with a collection of videos for the matching movie.
    func videosPublisher(forMovie movieID: MovieDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError>

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
    func recommendationsPublisher(forMovie movieID: MovieDTO.ID,
                                  page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

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
    func moviesPublisher(similarToMovie movieID: MovieDTO.ID,
                         page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

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
    func popularMoviesPublisher(page: Int?) -> AnyPublisher<MoviePageableListDTO, TMDbError>

}

public extension MovieAPI {

    func reviewsPublisher(forMovie movieID: MovieDTO.ID,
                          page: Int? = nil) -> AnyPublisher<ReviewPageableListDTO, TMDbError> {
        reviewsPublisher(forMovie: movieID, page: page)
    }

    func recommendationsPublisher(forMovie movieID: MovieDTO.ID,
                                  page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        recommendationsPublisher(forMovie: movieID, page: page)
    }

    func moviesPublisher(similarToMovie movieID: MovieDTO.ID,
                         page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        moviesPublisher(similarToMovie: movieID, page: page)
    }

    func popularMoviesPublisher(page: Int? = nil) -> AnyPublisher<MoviePageableListDTO, TMDbError> {
        popularMoviesPublisher(page: page)
    }

}
