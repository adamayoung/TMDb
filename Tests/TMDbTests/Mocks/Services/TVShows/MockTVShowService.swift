import Combine
@testable import TMDb
import XCTest

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

    func fetchDetails(forTVShow id: TVShow.ID) -> AnyPublisher<TVShow, TMDbError> {
        lastTVShowDetailsID = id

        guard let tvShowDetails = tvShowDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShowDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchCredits(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        lastCreditsTVShowID = tvShowID

        guard let credits = credits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(credits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchReviews(forTVShow tvShowID: TVShow.ID, page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError> {
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

    func fetchImages(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        lastImagesTVShowID = tvShowID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchVideos(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        lastVideosTVShowID = tvShowID

        guard let videos = videos else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(videos)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchRecommendations(forTVShow tvShowID: TVShow.ID,
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

    func fetchSimilar(toTVShow tvShowID: TVShow.ID, page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
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

    func fetchPopular(page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
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
