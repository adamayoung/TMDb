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
