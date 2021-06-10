import Foundation

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension MovieService {

    /// Returns the primary information about a movie.
    ///
    /// - Note: [TMDb API - Movie: Details](https://developers.themoviedb.org/3/movies/get-movie-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the movie.
    ///
    /// - Returns: The matching movie.
    func details(forMovie id: Movie.ID) async throws -> Movie {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchDetails(forMovie: id, completion: continuation.resume(with:))
        }
    }

    /// Returns the cast and crew of a movie.
    ///
    /// - Note: [TMDb API - Movie: Credits](https://developers.themoviedb.org/3/movies/get-movie-credits)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: Credits for the matching movie.
    func credits(forMovie movieID: Movie.ID) async throws -> ShowCredits {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchCredits(forMovie: movieID, completion: continuation.resume(with:))
        }
    }

    /// Returns the user reviews for a movie.
    ///
    /// - Note: [TMDb API - Movie: Reviews](https://developers.themoviedb.org/3/movies/get-movie-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Reviews for the matching movie as a pageable list.
    func reviews(forMovie movieID: Movie.ID, page: Int? = nil) async throws -> ReviewPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchReviews(forMovie: movieID, page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns the images that belong to a movie.
    ///
    /// - Note: [TMDb API - Movie: Images](https://developers.themoviedb.org/3/movies/get-movie-images)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: Collection of images for the matching movie.
    func images(forMovie movieID: Movie.ID) async throws -> ImageCollection {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchImages(forMovie: movieID, completion: continuation.resume(with:))
        }
    }

    /// Returns the videos that have been added to a movie.
    ///
    /// - Note: [TMDb API - Movie: Videos](https://developers.themoviedb.org/3/movies/get-movie-videos)
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie.
    ///
    /// - Returns: Collection of videos for the matching movie.
    func videos(forMovie movieID: Movie.ID) async throws -> VideoCollection {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchVideos(forMovie: movieID, completion: continuation.resume(with:))
        }
    }

    /// Returns a list of recommended movies for a movie.
    ///
    /// - Note: [TMDb API - Movie: Recommendations](https://developers.themoviedb.org/3/movies/get-movie-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - movieID: The identifier of the movie for get recommendations for.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Recommended movies for the matching movie as a pageable list.
    func recommendations(forMovie movieID: Movie.ID, page: Int? = nil) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchRecommendations(forMovie: movieID, page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns a list of similar movies for a movie.
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
    /// - Returns: Similar movies for the matching movie as a pageable list.
    func similar(toMovie movieID: Movie.ID, page: Int? = nil) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchSimilar(toMovie: movieID, page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns a list of currently playing movies.
    ///
    /// - Note: [TMDb API - Movie: Now Playing](https://developers.themoviedb.org/3/movies/get-now-playing)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    func nowPlaying(page: Int? = nil) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchNowPlaying(page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns a list of current popular movies.
    ///
    /// - Note: [TMDb API - Movie: Popular](https://developers.themoviedb.org/3/movies/get-popular-movies)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    func popular(page: Int? = nil) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchPopular(page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns a list of top rated movies.
    ///
    /// - Note: [TMDb API - Movie: Top Rated](https://developers.themoviedb.org/3/movies/get-top-rated-movies)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    func topRated(page: Int? = nil) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchTopRated(page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns a list of upcoming movies.
    ///
    /// - Note: [TMDb API - Movie: Upcoming](https://developers.themoviedb.org/3/movies/get-upcoming)
    ///
    /// - precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular movies as a pageable list.
    func upcoming(page: Int? = nil) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchUpcoming(page: page, completion: continuation.resume(with:))
        }
    }

}
#endif
