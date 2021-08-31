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
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension TMDbConfigurationService {

    func apiConfigurationPublisher() -> AnyPublisher<APIConfiguration, TMDbError> {
        apiClient.get(endpoint: ConfigurationEndpoint.api)
    }

}
#endif

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension TMDbConfigurationService {

    func apiConfiguration() async throws -> APIConfiguration {
        try await apiClient.get(endpoint: ConfigurationEndpoint.api)
    }

}
#endif
