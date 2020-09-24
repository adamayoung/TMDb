import Combine
@testable import TMDb
import XCTest

final class MockConfigurationService: ConfigurationService {

    var apiConfiguration: APIConfigurationDTO?

    func fetchAPIConfiguration() -> AnyPublisher<APIConfigurationDTO, TMDbError> {
        guard let apiConfiguration = apiConfiguration else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(apiConfiguration)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
