import Foundation

final class TMDbTVShowEpisodeService: TVShowEpisodeService {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func details(forEpisode episodeNumber: Int, inSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> TVShowEpisode {
        try await apiClient.get(endpoint: TVShowEpisodesEndpoint.details(tvShowID: tvShowID, seasonNumber: seasonNumber, episodeNumber: episodeNumber))
    }

    func images(forEpisode episodeNumber: Int, inSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        try await apiClient.get(endpoint: TVShowEpisodesEndpoint.images(tvShowID: tvShowID, seasonNumber: seasonNumber, episodeNumber: episodeNumber))
    }

    func videos(forEpisode episodeNumber: Int, inSeason seasonNumber: Int, inTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        try await apiClient.get(endpoint: TVShowEpisodesEndpoint.videos(tvShowID: tvShowID, seasonNumber: seasonNumber, episodeNumber: episodeNumber))
    }

}