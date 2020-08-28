import Combine
import Foundation

public final class TMDbTVShowSeasonService: TVShowSeasonService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    public func fetchDetails(forSeasonNumber seasonNumber: Int,
                             inTVShow tvShowID: TVShow.ID) -> AnyPublisher<TVShowSeason, TMDbError> {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

    public func fetchImages(forSeasonNumber seasonNumber: Int,
                            inTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

    public func fetchVideos(forSeasonNumber seasonNumber: Int,
                            inTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

}
