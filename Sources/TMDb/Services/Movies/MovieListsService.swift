import Foundation

/// A service to fetch various curated lists of movies.
public protocol MovieListsService {

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
    func recommendations(forMovie movieID: Movie.ID, page: Int?) async throws -> MoviePageableList

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
    func similar(toMovie movieID: Movie.ID, page: Int?) async throws -> MoviePageableList

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
    func nowPlaying(page: Int?) async throws -> MoviePageableList

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
    func popular(page: Int?) async throws -> MoviePageableList

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
    func topRated(page: Int?) async throws -> MoviePageableList

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
    func upcoming(page: Int?) async throws -> MoviePageableList

}

public extension MovieListsService {

    func recommendations(forMovie movieID: Movie.ID, page: Int? = nil) async throws -> MoviePageableList {
        try await recommendations(forMovie: movieID, page: page)
    }

    func similar(toMovie movieID: Movie.ID, page: Int? = nil) async throws -> MoviePageableList {
        try await similar(toMovie: movieID, page: page)
    }

    func nowPlaying(page: Int? = nil) async throws -> MoviePageableList {
        try await nowPlaying(page: page)
    }

    func popular(page: Int? = nil) async throws -> MoviePageableList {
        try await popular(page: page)
    }

    func topRated(page: Int? = nil) async throws -> MoviePageableList {
        try await topRated(page: page)
    }

    func upcoming(page: Int? = nil) async throws -> MoviePageableList {
        try await upcoming(page: page)
    }

}
