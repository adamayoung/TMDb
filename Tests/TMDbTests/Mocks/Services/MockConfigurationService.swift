@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

final class MockConfigurationService: ConfigurationService {

    var apiConfiguration: APIConfiguration?

    func fetchAPIConfiguration(completion: @escaping (Result<APIConfiguration, TMDbError>) -> Void) {
        guard let apiConfiguration = apiConfiguration else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(apiConfiguration))
        }
    }

}

#if canImport(Combine)
extension MockConfigurationService {

    func apiConfigurationPublisher() -> AnyPublisher<APIConfiguration, TMDbError> {
        guard let apiConfiguration = apiConfiguration else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(apiConfiguration)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
#endif

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension MockConfigurationService {

    func apiConfiguration() async throws -> APIConfiguration {
        try await withCheckedThrowingContinuation { continuation in
            guard let apiConfiguration = self.apiConfiguration else {
                return
            }

            continuation.resume(returning: apiConfiguration)
        }
    }

}
#endif
