import Combine
import Foundation

public final class TMDbTVShowSeasonService: TVShowSeasonService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchDetails(forSeason seasonNumber: Int,
                      inTVShow tvShowID: TVShow.ID) -> AnyPublisher<TVShowSeason, TMDbError> {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

    func fetchImages(forSeason seasonNumber: Int,
                     inTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

    func fetchVideos(forSeason seasonNumber: Int,
                     inTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

}
