import Foundation

final class TMDbWatchProviderService: WatchProviderService {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func countries() async throws -> [Country] {
        let regions: WatchProviderRegions = try await apiClient.get(endpoint: WatchProviderEndpoint.regions)
        return regions.results
    }

    func movieWatchProviders() async throws -> [WatchProvider] {
        let result: WatchProviderResult = try await apiClient.get(endpoint: WatchProviderEndpoint.movie)
        return result.results
    }

}
