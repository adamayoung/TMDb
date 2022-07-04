import Foundation

/// A service to fetch reviews for a movie.
public protocol MovieReviewService {

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
    func reviews(forMovie movieID: Movie.ID, page: Int?) async throws -> ReviewPageableList

}

public extension MovieReviewService {

    func reviews(forMovie movieID: Movie.ID, page: Int? = nil) async throws -> ReviewPageableList {
        try await reviews(forMovie: movieID, page: page)
    }

}
