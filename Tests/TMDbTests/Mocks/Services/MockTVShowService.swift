@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

final class MockTVShowService: TVShowService {

    var tvShowDetails: TVShow?
    private(set) var lastTVShowDetailsID: TVShow.ID?
    var credits: ShowCredits?
    private(set) var lastCreditsTVShowID: TVShow.ID?
    var reviews: ReviewPageableList?
    private(set) var lastReviewsTVShowID: TVShow.ID?
    private(set) var lastReviewsPage: Int?
    var images: ImageCollection?
    private(set) var lastImagesTVShowID: TVShow.ID?
    var videos: VideoCollection?
    private(set) var lastVideosTVShowID: TVShow.ID?
    var recommendations: TVShowPageableList?
    private(set) var lastRecommendationsTVShowID: TVShow.ID?
    private(set) var lastRecommendationsPage: Int?
    var similar: TVShowPageableList?
    private(set) var lastSimilarTVShowID: TVShow.ID?
    private(set) var lastSimilarPage: Int?
    var popular: TVShowPageableList?
    private(set) var lastPopularPage: Int?

    func fetchDetails(forTVShow id: TVShow.ID, completion: @escaping (_ result: Result<TVShow, TMDbError>) -> Void) {
        lastTVShowDetailsID = id

        guard let tvShowDetails = tvShowDetails else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(tvShowDetails))
        }
    }

    func fetchCredits(forTVShow tvShowID: TVShow.ID,
                      completion: @escaping (Result<ShowCredits, TMDbError>) -> Void) {
        lastCreditsTVShowID = tvShowID

        guard let credits = credits else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(credits))
        }
    }

    func fetchReviews(forTVShow tvShowID: TVShow.ID, page: Int?,
                      completion: @escaping (Result<ReviewPageableList, TMDbError>) -> Void) {
        lastReviewsTVShowID = tvShowID
        lastReviewsPage = page

        guard let reviews = reviews else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(reviews))
        }
    }

    func fetchImages(forTVShow tvShowID: TVShow.ID,
                     completion: @escaping (Result<ImageCollection, TMDbError>) -> Void) {
        lastImagesTVShowID = tvShowID

        guard let images = images else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(images))
        }
    }

    func fetchVideos(forTVShow tvShowID: TVShow.ID,
                     completion: @escaping (Result<VideoCollection, TMDbError>) -> Void) {
        lastVideosTVShowID = tvShowID

        guard let videos = videos else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(videos))
        }
    }

    func fetchRecommendations(forTVShow tvShowID: TVShow.ID, page: Int?,
                              completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        lastRecommendationsTVShowID = tvShowID
        lastRecommendationsPage = page

        guard let recommendations = recommendations else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(recommendations))
        }
    }

    func fetchSimilar(toTVShow tvShowID: TVShow.ID, page: Int?,
                      completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        lastSimilarTVShowID = tvShowID
        lastSimilarPage = page

        guard let similar = similar else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(similar))
        }
    }

    func fetchPopular(page: Int?, completion: @escaping (Result<TVShowPageableList, TMDbError>) -> Void) {
        lastPopularPage = page

        guard let popular = popular else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(popular))
        }
    }

}

#if canImport(Combine)
extension MockTVShowService {

    func detailsPublisher(forTVShow id: TVShow.ID) -> AnyPublisher<TVShow, TMDbError> {
        lastTVShowDetailsID = id

        guard let tvShowDetails = tvShowDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShowDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func creditsPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        lastCreditsTVShowID = tvShowID

        guard let credits = credits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(credits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func reviewsPublisher(forTVShow tvShowID: TVShow.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError> {
        lastReviewsTVShowID = tvShowID
        lastReviewsPage = page

        guard let reviews = reviews else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(reviews)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func imagesPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        lastImagesTVShowID = tvShowID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func videosPublisher(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        lastVideosTVShowID = tvShowID

        guard let videos = videos else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(videos)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func recommendationsPublisher(forTVShow tvShowID: TVShow.ID,
                                  page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        lastRecommendationsTVShowID = tvShowID
        lastRecommendationsPage = page

        guard let recommendations = recommendations else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(recommendations)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func similarPublisher(toTVShow tvShowID: TVShow.ID, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        lastSimilarTVShowID = tvShowID
        lastSimilarPage = page

        guard let similar = similar else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(similar)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func popularPublisher(page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        lastPopularPage = page

        guard let popular = popular else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(popular)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
#endif

#if swift(>=5.5) && !os(Linux)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension MockTVShowService {

    func details(forTVShow id: TVShow.ID) async throws -> TVShow {
        lastTVShowDetailsID = id

        return try await withCheckedThrowingContinuation { continuation in
            guard let tvShowDetails = self.tvShowDetails else {
                return
            }

            continuation.resume(returning: tvShowDetails)
        }
    }

    func credits(forTVShow tvShowID: TVShow.ID) async throws -> ShowCredits {
        lastCreditsTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let credits = self.credits else {
                return
            }

            continuation.resume(returning: credits)
        }
    }

    func reviews(forTVShow tvShowID: TVShow.ID, page: Int?) async throws -> ReviewPageableList {
        lastReviewsTVShowID = tvShowID
        lastReviewsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let reviews = self.reviews else {
                return
            }

            continuation.resume(returning: reviews)
        }
    }

    func images(forTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        lastImagesTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let images = self.images else {
                return
            }

            continuation.resume(returning: images)
        }
    }

    func videos(forTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        lastVideosTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let videos = self.videos else {
                return
            }

            continuation.resume(returning: videos)
        }
    }

    func recommendations(forTVShow tvShowID: TVShow.ID, page: Int?) async throws -> TVShowPageableList {
        lastRecommendationsTVShowID = tvShowID
        lastRecommendationsPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let recommendations = self.recommendations else {
                return
            }

            continuation.resume(returning: recommendations)
        }
    }

    func similar(toTVShow tvShowID: TVShow.ID, page: Int?) async throws -> TVShowPageableList {
        lastSimilarTVShowID = tvShowID
        lastSimilarPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let similar = self.similar else {
                return
            }

            continuation.resume(returning: similar)
        }
    }

    func popular(page: Int?) async throws -> TVShowPageableList {
        lastPopularPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let popular = self.popular else {
                return
            }

            continuation.resume(returning: popular)
        }
    }

}
#endif
