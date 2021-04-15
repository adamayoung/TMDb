import Combine
@testable import TMDb
import XCTest

final class MockConfigurationService: ConfigurationService {

    var apiConfiguration: APIConfiguration?

    func fetchAPIConfiguration() -> AnyPublisher<APIConfiguration, TMDbError> {
        guard let apiConfiguration = apiConfiguration else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(apiConfiguration)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
