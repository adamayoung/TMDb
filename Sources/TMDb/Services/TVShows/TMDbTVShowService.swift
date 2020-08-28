import Combine
import Foundation

public final class TMDbTVShowService: TVShowService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    public func fetchDetails(forTVShow id: TVShow.ID) -> AnyPublisher<TVShow, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.details(tvShowID: id))
    }

    public func fetchCredits(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.credits(tvShowID: tvShowID))
    }

    public func fetchReviews(forTVShow tvShowID: TVShow.ID,
                             page: Int?) -> AnyPublisher<ReviewPageableListResult, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page))
    }

    public func fetchImages(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.images(tvShowID: tvShowID))
    }

    public func fetchVideos(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.videos(tvShowID: tvShowID))
    }

    public func fetchRecommendations(forTVShow tvShowID: TVShow.ID,
                                     page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page))
    }

    public func fetchSimilar(toTVShow tvShowID: TVShow.ID,
                             page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.similar(tvShowID: tvShowID, page: page))
    }

    public func fetchPopular(page: Int?) -> AnyPublisher<TVShowPageableListResult, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.popular(page: page))
    }

}
