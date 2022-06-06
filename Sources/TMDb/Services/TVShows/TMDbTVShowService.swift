import Foundation

final class TMDbTVShowService: TVShowService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func details(forTVShow id: TVShow.ID) async throws -> TVShow {
        try await apiClient.get(endpoint: TVShowsEndpoint.details(tvShowID: id))
    }

    func credits(forTVShow tvShowID: TVShow.ID) async throws -> ShowCredits {
        try await apiClient.get(endpoint: TVShowsEndpoint.credits(tvShowID: tvShowID))
    }

    func reviews(forTVShow tvShowID: TVShow.ID, page: Int?) async throws -> ReviewPageableList {
        try await apiClient.get(endpoint: TVShowsEndpoint.reviews(tvShowID: tvShowID, page: page))
    }

    func images(forTVShow tvShowID: TVShow.ID) async throws -> ImageCollection {
        try await apiClient.get(endpoint: TVShowsEndpoint.images(tvShowID: tvShowID))
    }

    func videos(forTVShow tvShowID: TVShow.ID) async throws -> VideoCollection {
        try await apiClient.get(endpoint: TVShowsEndpoint.videos(tvShowID: tvShowID))
    }

    func recommendations(forTVShow tvShowID: TVShow.ID, page: Int?) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: TVShowsEndpoint.recommendations(tvShowID: tvShowID, page: page))
    }

    func similar(toTVShow tvShowID: TVShow.ID, page: Int?) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: TVShowsEndpoint.similar(tvShowID: tvShowID, page: page))
    }

    func popular(page: Int?) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: TVShowsEndpoint.popular(page: page))
    }

}
