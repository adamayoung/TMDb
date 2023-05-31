import Foundation

public final class MovieService {

    private let apiClient: APIClient

    public convenience init(config: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(apiKey: config.apiKey)
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns the primary information about a movie.
    ///
    /// [TMDb API - Movie: Details](https://developers.themoviedb.org/3/movies/get-movie-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the movie.
    ///
    /// - Returns: The matching movie.
    /// 
    public func details(forMovie id: Movie.ID) async throws -> Movie {
        try await apiClient.get(endpoint: MoviesEndpoint.details(movieID: id))
    }

    ///
    /// Returns the cast and crew of a movie.
    ///
    /// [TMDb API - Movie: Credits](https://developers.themoviedb.org/3/movies/get-movie-credits)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: Credits for the matching movie.
    /// 
    public func credits(forMovie movieID: Movie.ID) async throws -> ShowCredits {
        try await apiClient.get(endpoint: MoviesEndpoint.credits(movieID: movieID))
    }

    ///
    /// Returns the user reviews for a movie.
    ///
    /// [TMDb API - Movie: Reviews](https://developers.themoviedb.org/3/movies/get-movie-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Reviews for the matching movie as a pageable list.
    /// 
    public func reviews(forMovie movieID: Movie.ID, page: Int? = nil) async throws -> ReviewPageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.reviews(movieID: movieID, page: page))
    }

    ///
    /// Returns the images that belong to a movie.
    ///
    /// [TMDb API - Movie: Images](https://developers.themoviedb.org/3/movies/get-movie-images)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: Collection of images for the matching movie.
    /// 
    public func images(forMovie movieID: Movie.ID) async throws -> ImageCollection {
        try await apiClient.get(endpoint: MoviesEndpoint.images(movieID: movieID))
    }

    ///
    /// Returns the videos that have been added to a movie.
    ///
    /// [TMDb API - Movie: Videos](https://developers.themoviedb.org/3/movies/get-movie-videos)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: Collection of videos for the matching movie.
    /// 
    public func videos(forMovie movieID: Movie.ID) async throws -> VideoCollection {
        try await apiClient.get(endpoint: MoviesEndpoint.videos(movieID: movieID))
    }

    ///
    /// Returns a list of recommended movies for a movie.
    ///
    /// [TMDb API - Movie: Recommendations](https://developers.themoviedb.org/3/movies/get-movie-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie for get recommendations for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Recommended movies for the matching movie as a pageable list.
    /// 
    public func recommendations(forMovie movieID: Movie.ID, page: Int? = nil) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.recommendations(movieID: movieID, page: page))
    }

    ///
    /// Returns a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - Movie: Similar](https://developers.themoviedb.org/3/movies/get-similar-movies)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie for get similar movies for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Similar movies for the matching movie as a pageable list.
    /// 
    public func similar(toMovie movieID: Movie.ID, page: Int? = nil) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.similar(movieID: movieID, page: page))
    }

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie: Now Playing](https://developers.themoviedb.org/3/movies/get-now-playing)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    /// 
    public func nowPlaying(page: Int? = nil) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.nowPlaying(page: page))
    }

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie: Popular](https://developers.themoviedb.org/3/movies/get-popular-movies)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    /// 
    public func popular(page: Int? = nil) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.popular(page: page))
    }

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie: Top Rated](https://developers.themoviedb.org/3/movies/get-top-rated-movies)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    /// 
    public func topRated(page: Int? = nil) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.topRated(page: page))
    }

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie: Upcoming](https://developers.themoviedb.org/3/movies/get-upcoming)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    /// 
    public func upcoming(page: Int? = nil) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: MoviesEndpoint.upcoming(page: page))
    }

}
