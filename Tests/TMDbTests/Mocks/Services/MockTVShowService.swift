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

    func details(forTVShow id: TVShow.ID) async throws -> TVShow {
        lastTVShowDetailsID = id

        return try await withCheckedThrowingContinuation { continuation in
            guard let tvShowDetails = self.tvShowDetails else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: tvShowDetails)
        }
    }

    func credits(forTVShow tvShowID: TVShow.ID) async throws -> ShowCredits {
        lastCreditsTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let credits = self.credits else {
                continuation.resume(throwing: MockDataMissingError())
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
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: reviews)
        }
    }

    func images(forTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        lastImagesTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let images = self.images else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: images)
        }
    }

    func videos(forTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        lastVideosTVShowID = tvShowID

        return try await withCheckedThrowingContinuation { continuation in
            guard let videos = self.videos else {
                continuation.resume(throwing: MockDataMissingError())
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
                continuation.resume(throwing: MockDataMissingError())
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
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: similar)
        }
    }

    func popular(page: Int?) async throws -> TVShowPageableList {
        lastPopularPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let popular = self.popular else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: popular)
        }
    }

}
