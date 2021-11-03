import Foundation

#if canImport(Combine)
import Combine
#endif

final class TMDbTVShowSeasonService: TVShowSeasonService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchDetails(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID,
                      completion: @escaping (Result<TVShowSeason, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber),
                      completion: completion)
    }

    func fetchImages(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID,
                     completion: @escaping (Result<ImageCollection, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber),
                      completion: completion)
    }

    func fetchVideos(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID,
                     completion: @escaping (Result<VideoCollection, TMDbError>) -> Void) {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber),
                      completion: completion)
    }

}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension TMDbTVShowSeasonService {

    func detailsPublisher(forSeason seasonNumber: Int,
                          inTVShow tvShowID: TVShow.ID) -> AnyPublisher<TVShowSeason, TMDbError> {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

    func imagesPublisher(forSeason seasonNumber: Int,
                         inTVShow tvShowID: TVShow.ID) -> AnyPublisher<ImageCollection, TMDbError> {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

    func videosPublisher(forSeason seasonNumber: Int,
                         inTVShow tvShowID: TVShow.ID) -> AnyPublisher<VideoCollection, TMDbError> {
        apiClient.get(endpoint: TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

}
#endif

#if swift(>=5.5) && !os(Linux)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension TMDbTVShowSeasonService {

    func details(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowSeason {
        try await apiClient.get(endpoint: TVShowSeasonsEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

    func images(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        try await apiClient.get(endpoint: TVShowSeasonsEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

    func videos(forSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        try await apiClient.get(endpoint: TVShowSeasonsEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }

}
#endif
