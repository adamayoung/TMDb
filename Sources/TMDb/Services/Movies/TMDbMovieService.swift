import Foundation

#if canImport(Combine)
import Combine
#endif

final class TMDbMovieService: MovieService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchDetails(forMovie id: Movie.ID, completion: @escaping (Result<Movie, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.details(movieID: id), completion: completion)
    }

    func fetchCredits(forMovie movieID: Movie.ID, completion: @escaping (Result<ShowCredits, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.credits(movieID: movieID), completion: completion)
    }

    func fetchReviews(forMovie movieID: Movie.ID, page: Int?,
                      completion: @escaping (Result<ReviewPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.reviews(movieID: movieID, page: page), completion: completion)
    }

    func fetchImages(forMovie movieID: Movie.ID, completion: @escaping (Result<ImageCollection, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.images(movieID: movieID), completion: completion)
    }

    func fetchVideos(forMovie movieID: Movie.ID, completion: @escaping (Result<VideoCollection, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.videos(movieID: movieID), completion: completion)
    }

    func fetchRecommendations(forMovie movieID: Movie.ID, page: Int?,
                              completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.recommendations(movieID: movieID, page: page), completion: completion)
    }

    func fetchSimilar(toMovie movieID: Movie.ID, page: Int?,
                      completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.similar(movieID: movieID, page: page), completion: completion)
    }

    func fetchNowPlaying(page: Int?, completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.nowPlaying(page: page), completion: completion)
    }

    func fetchPopular(page: Int?, completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.popular(page: page), completion: completion)
    }

    func fetchTopRated(page: Int?, completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.topRated(page: page), completion: completion)
    }

    func fetchUpcoming(page: Int?, completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: MoviesEndpoint.upcoming(page: page), completion: completion)
    }

}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension TMDbMovieService {

    func detailsPublisher(forMovie id: Movie.ID) -> AnyPublisher<Movie, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.details(movieID: id))
    }

    func creditsPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.credits(movieID: movieID))
    }

    func reviewsPublisher(forMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.reviews(movieID: movieID, page: page))
    }

    func imagesPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.images(movieID: movieID))
    }

    func videosPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.videos(movieID: movieID))
    }

    func recommendationsPublisher(forMovie movieID: Movie.ID,
                                  page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.recommendations(movieID: movieID, page: page))
    }

    func similarPublisher(toMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.similar(movieID: movieID, page: page))
    }

    func nowPlayingPublisher(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.nowPlaying(page: page))
    }

    func popularPublisher(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.popular(page: page))
    }

    func topRatedPublisher(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.topRated(page: page))
    }

    func upcomingPublisher(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        apiClient.get(endpoint: MoviesEndpoint.upcoming(page: page))
    }

}
#endif

@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension TMDbMovieService {

    func details(forMovie id: Movie.ID) async throws -> Movie {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchDetails(forMovie: id, completion: continuation.resume(with:))
        }
    }

    func credits(forMovie movieID: Movie.ID) async throws -> ShowCredits {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchCredits(forMovie: movieID, completion: continuation.resume(with:))
        }
    }

    func reviews(forMovie movieID: Movie.ID, page: Int?) async throws -> ReviewPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchReviews(forMovie: movieID, page: page, completion: continuation.resume(with:))
        }
    }

    func images(forMovie movieID: Movie.ID) async throws -> ImageCollection {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchImages(forMovie: movieID, completion: continuation.resume(with:))
        }
    }

    func videos(forMovie movieID: Movie.ID) async throws -> VideoCollection {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchVideos(forMovie: movieID, completion: continuation.resume(with:))
        }
    }

    func recommendations(forMovie movieID: Movie.ID, page: Int?) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchRecommendations(forMovie: movieID, page: page, completion: continuation.resume(with:))
        }
    }

    func similar(toMovie movieID: Movie.ID, page: Int?) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchSimilar(toMovie: movieID, page: page, completion: continuation.resume(with:))
        }
    }

    func nowPlaying(page: Int?) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchNowPlaying(page: page, completion: continuation.resume(with:))
        }
    }

    func popular(page: Int?) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchPopular(page: page, completion: continuation.resume(with:))
        }
    }

    func topRated(page: Int?) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchTopRated(page: page, completion: continuation.resume(with:))
        }
    }

    func upcoming(page: Int?) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchUpcoming(page: page, completion: continuation.resume(with:))
        }
    }

}
