import Foundation

#if canImport(Combine)
import Combine
#endif

final class TMDbConfigurationService: ConfigurationService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchAPIConfiguration(completion: @escaping (Result<APIConfiguration, TMDbError>) -> Void) {
        apiClient.get(endpoint: ConfigurationEndpoint.api, completion: completion)
    }

}

#if canImport(Combine)
extension TMDbConfigurationService {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func apiConfigurationPublisher() -> AnyPublisher<APIConfiguration, TMDbError> {
        apiClient.get(endpoint: ConfigurationEndpoint.api)
    }

}
#endif
