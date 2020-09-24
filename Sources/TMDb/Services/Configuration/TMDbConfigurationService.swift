import Combine
import Foundation

final class TMDbConfigurationService: ConfigurationService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchAPIConfiguration() -> AnyPublisher<APIConfigurationDTO, TMDbError> {
        apiClient.get(endpoint: ConfigurationEndpoint.api)
    }

}
