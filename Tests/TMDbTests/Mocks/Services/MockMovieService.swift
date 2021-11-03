@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

final class MockMovieService: MovieService {

    var movieDetails: Movie?
    private(set) var lastMovieDetailsID: Movie.ID?
    var credits: ShowCredits?
    private(set) var lastCreditsMovieID: Movie.ID?
    var reviews: ReviewPageableList?
    private(set) var lastReviewsMovieID: Movie.ID?
    private(set) var lastReviewsPage: Int?
    var images: ImageCollection?
    private(set) var lastImagesMovieID: Movie.ID?
    var videos: VideoCollection?
    private(set) var lastVideosMovieID: Movie.ID?
    var recommendations: MoviePageableList?
    private(set) var lastRecommendationsMovieID: Movie.ID?
    private(set) var lastRecommendationsPage: Int?
    var similar: MoviePageableList?
    private(set) var lastSimilarMovieID: Movie.ID?
    private(set) var lastSimilarPage: Int?
    var nowPlaying: MoviePageableList?
    private(set) var lastNowPlayingPage: Int?
    var popular: MoviePageableList?
    private(set) var lastPopularPage: Int?
    var topRated: MoviePageableList?
    private(set) var lastTopRatedPage: Int?
    var upcoming: MoviePageableList?
    private(set) var lastUpcomingPage: Int?

    func fetchDetails(forMovie id: Movie.ID, completion: @escaping (Result<Movie, TMDbError>) -> Void) {
        lastMovieDetailsID = id

        guard let movieDetails = movieDetails else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(movieDetails))
        }
    }

    func fetchCredits(forMovie movieID: Movie.ID, completion: @escaping (Result<ShowCredits, TMDbError>) -> Void) {
        lastCreditsMovieID = movieID

        guard let credits = credits else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(credits))
        }
    }

    func fetchReviews(forMovie movieID: Movie.ID, page: Int?,
                      completion: @escaping (Result<ReviewPageableList, TMDbError>) -> Void) {
        lastReviewsMovieID = movieID
        lastReviewsPage = page

        guard let reviews = reviews else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(reviews))
        }
    }

    func fetchImages(forMovie movieID: Movie.ID, completion: @escaping (Result<ImageCollection, TMDbError>) -> Void) {
        lastImagesMovieID = movieID

        guard let images = images else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(images))
        }
    }

    func fetchVideos(forMovie movieID: Movie.ID, completion: @escaping (Result<VideoCollection, TMDbError>) -> Void) {
        lastVideosMovieID = movieID

        guard let videos = videos else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(videos))
        }
    }

    func fetchRecommendations(forMovie movieID: Movie.ID, page: Int?,
                              completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastRecommendationsMovieID = movieID
        lastRecommendationsPage = page

        guard let recommendations = recommendations else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(recommendations))
        }
    }

    func fetchSimilar(toMovie movieID: Movie.ID, page: Int?,
                      completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastSimilarMovieID = movieID
        lastSimilarPage = page

        guard let similar = similar else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(similar))
        }
    }

    func fetchNowPlaying(page: Int?, completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastNowPlayingPage = page

        guard let nowPlaying = nowPlaying else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(nowPlaying))
        }
    }

    func fetchPopular(page: Int?, completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastPopularPage = page

        guard let popular = popular else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(popular))
        }
    }

    func fetchTopRated(page: Int?, completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastTopRatedPage = page

        guard let topRated = topRated else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(topRated))
        }
    }

    func fetchUpcoming(page: Int?, completion: @escaping (Result<MoviePageableList, TMDbError>) -> Void) {
        lastUpcomingPage = page

        guard let upcoming = upcoming else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(upcoming))
        }
    }

}

#if canImport(Combine)
extension MockMovieService {

    func detailsPublisher(forMovie id: Movie.ID) -> AnyPublisher<Movie, TMDbError> {
        lastMovieDetailsID = id

        guard let movieDetails = movieDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movieDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func creditsPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        lastCreditsMovieID = movieID

        guard let credits = credits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(credits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func reviewsPublisher(forMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError> {
        lastReviewsMovieID = movieID
        lastReviewsPage = page

        guard let reviews = reviews else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(reviews)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func imagesPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        lastImagesMovieID = movieID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func videosPublisher(forMovie movieID: Movie.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        lastVideosMovieID = movieID

        guard let videos = videos else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(videos)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func recommendationsPublisher(forMovie movieID: Movie.ID,
                                  page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastRecommendationsMovieID = movieID
        lastRecommendationsPage = page

        guard let recommendations = recommendations else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(recommendations)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func similarPublisher(toMovie movieID: Movie.ID, page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastSimilarMovieID = movieID
        lastSimilarPage = page

        guard let similar = similar else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(similar)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func nowPlayingPublisher(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastNowPlayingPage = page

        guard let nowPlaying = nowPlaying else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(nowPlaying)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func popularPublisher(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastPopularPage = page

        guard let popular = popular else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(popular)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func topRatedPublisher(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastTopRatedPage = page

        guard let topRated = topRated else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(topRated)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func upcomingPublisher(page: Int?) -> AnyPublisher<MoviePageableList, TMDbError> {
        lastUpcomingPage = page

        guard let upcoming = upcoming else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(upcoming)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
#endif

#if swift(>=5.5) && !os(Linux)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension MockMovieService {

    func details(forMovie id: Movie.ID) async throws -> Movie {
        lastMovieDetailsID = id

        return try await withCheckedThrowingContinuation { continuation in
            guard let movieDetails = self.movieDetails else {
                return
            }

            continuation.resume(returning: movieDetails)
        }
    }

    func credits(forMovie movieID: Movie.ID) async throws -> ShowCredits {
        lastCreditsMovieID = movieID

        return try await withCheckedThrowingContinuation { continuation in
            guard let credits = self.credits else {
                return
            }

            continuation.resume(returning: credits)
        }
    }

    func reviews(forMovie movieID: Movie.ID, page: Int?) async throws -> ReviewPageableList {
        lastReviewsMovieID = movieID
        lastReviewsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let reviews = self.reviews else {
                return
            }

            continuation.resume(returning: reviews)
        }
    }

    func images(forMovie movieID: Movie.ID) async throws -> ImageCollection {
        lastImagesMovieID = movieID

        return try await withCheckedThrowingContinuation { continuation in
            guard let images = self.images else {
                return
            }

            continuation.resume(returning: images)
        }
    }

    func videos(forMovie movieID: Movie.ID) async throws -> VideoCollection {
        lastVideosMovieID = movieID

        return try await withCheckedThrowingContinuation { continuation in
            guard let videos = self.videos else {
                return
            }

            continuation.resume(returning: videos)
        }
    }

    func recommendations(forMovie movieID: Movie.ID,
                         page: Int?) async throws -> MoviePageableList {
        lastRecommendationsMovieID = movieID
        lastRecommendationsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let recommendations = self.recommendations else {
                return
            }

            continuation.resume(returning: recommendations)
        }
    }

    func similar(toMovie movieID: Movie.ID, page: Int?) async throws -> MoviePageableList {
        lastSimilarMovieID = movieID
        lastSimilarPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let similar = self.similar else {
                return
            }

            continuation.resume(returning: similar)
        }
    }

    func nowPlaying(page: Int?) async throws -> MoviePageableList {
        lastNowPlayingPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let nowPlaying = self.nowPlaying else {
                return
            }

            continuation.resume(returning: nowPlaying)
        }
    }

    func popular(page: Int?) async throws -> MoviePageableList {
        lastPopularPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let popular = self.popular else {
                return
            }

            continuation.resume(returning: popular)
        }
    }

    func topRated(page: Int?) async throws -> MoviePageableList {
        lastTopRatedPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let topRated = self.topRated else {
                return
            }

            continuation.resume(returning: topRated)
        }
    }

    func upcoming(page: Int?) async throws -> MoviePageableList {
        lastUpcomingPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let upcoming = self.upcoming else {
                return
            }

            continuation.resume(returning: upcoming)
        }
    }

}
#endif
