import Combine
import Foundation

public final class TMDbTVShowService: TVShowService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchDetails(forTVShow id: TVShowDTO.ID) -> AnyPublisher<TVShowDTO, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.details(tvShowID: id))
    }

    func fetchCredits(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ShowCreditsDTO, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.credits(tvShowID: tvShowID))
    }

    func fetchReviews(forTVShow tvShowID: TVShowDTO.ID,
                      page: Int?) -> AnyPublisher<ReviewPageableListDTO, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page))
    }

    func fetchImages(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<ImageCollectionDTO, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.images(tvShowID: tvShowID))
    }

    func fetchVideos(forTVShow tvShowID: TVShowDTO.ID) -> AnyPublisher<VideoCollectionDTO, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.videos(tvShowID: tvShowID))
    }

    func fetchRecommendations(forTVShow tvShowID: TVShowDTO.ID,
                              page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page))
    }

    func fetchSimilar(toTVShow tvShowID: TVShowDTO.ID,
                      page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.similar(tvShowID: tvShowID, page: page))
    }

    func fetchPopular(page: Int?) -> AnyPublisher<TVShowPageableListDTO, TMDbError> {
        apiClient.get(endpoint: TVShowsEndpoint.popular(page: page))
    }

}
