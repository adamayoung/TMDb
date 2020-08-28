import Combine
import Foundation

public final class TMDbConfigurationService: ConfigurationService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    public func fetchAPIConfiguration() -> AnyPublisher<APIConfiguration, TMDbError> {
        apiClient.get(endpoint: ConfigurationEndpoint.api)
    }

}
