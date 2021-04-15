import Combine
import Foundation

public final class TMDbTVShowService: TVShowService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchDetails(forTVShow id: TVShow.ID) -> AnyPublisher<TVShow, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.details(tvShowID: id))
    }

    func fetchCredits(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ShowCredits, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.credits(tvShowID: tvShowID))
    }

    func fetchReviews(forTVShow tvShowID: TVShow.ID,
                      page: Int?) -> AnyPublisher<ReviewPageableList, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page))
    }

    func fetchImages(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.images(tvShowID: tvShowID))
    }

    func fetchVideos(forTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.videos(tvShowID: tvShowID))
    }

    func fetchRecommendations(forTVShow tvShowID: TVShow.ID,
                              page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page))
    }

    func fetchSimilar(toTVShow tvShowID: TVShow.ID,
                      page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.similar(tvShowID: tvShowID, page: page))
    }

    func fetchPopular(page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.popular(page: page))
    }

}
