import Foundation

final class TMDbConfigurationService: ConfigurationService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func apiConfiguration() async throws -> APIConfiguration {
        try await apiClient.get(endpoint: ConfigurationEndpoint.api)
    }

}
