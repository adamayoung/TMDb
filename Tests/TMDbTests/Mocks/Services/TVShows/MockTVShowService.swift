import Combine
@testable import TMDb
import XCTest

final class MockTVShowService: TVShowService {

    var tvShowDetails: TVShowDTO?
    private(set) var lastTVShowDetailsID: TVShowDTO.ID?
    var credits: ShowCreditsDTO?
    private(set) var lastCreditsTVShowID: TVShowDTO.ID?
    var reviews: ReviewPageableListDTO?
    private(set) var lastReviewsTVShowID: TVShowDTO.ID?
    private(set) var lastReviewsPage: Int?
    var images: ImageCollectionDTO?
    private(set) var lastImagesTVShowID: TVShowDTO.ID?
    var videos: VideoCollectionDTO?
    private(set) var lastVideosTVShowID: TVShowDTO.ID?
    var recommendations: TVShowPageableListDTO?
    private(set) var lastRecommendationsTVShowID: TVShowDTO.ID?
    private(set) var lastRecommendationsPage: Int?
    var similar: TVShowPageableListDTO?
    private(set) var lastSimilarTVShowID: TVShowDTO.ID?
    private(set) var lastSimilarPage: Int?
    var popular: TVShowPageableListDTO?
    private(set) var lastPopularPage: Int?

    func fetchDetails(forTVShow id: TVShowDTO.ID) -> AnyPublisher<TVShowDTO, TMDbError> {
        lastTVShowDetailsID = id

        guard let tvShowDetails = tvShowDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShowDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchCredits(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ShowCreditsDTO, TMDbError> {
        lastCreditsTVShowID = tvShowID

        guard let credits = credits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(credits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchReviews(forTVShow tvShowID: TVShowDTO.ID, page: Int?) -> AnyPublisher<ReviewPageableListDTO, TMDbError> {
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

    func fetchImages(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError> {
        lastImagesTVShowID = tvShowID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchVideos(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError> {
        lastVideosTVShowID = tvShowID

        guard let videos = videos else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(videos)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchRecommendations(forTVShow tvShowID: TVShowDTO.ID,
                              page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
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

    func fetchSimilar(toTVShow tvShowID: TVShowDTO.ID, page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
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

    func fetchPopular(page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
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
