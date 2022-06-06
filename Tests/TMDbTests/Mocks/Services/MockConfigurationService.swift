@testable import TMDb
import XCTest

final class MockConfigurationService: ConfigurationService {

    var apiConfiguration: APIConfiguration?

    func apiConfiguration() async throws -> APIConfiguration {
        try await withCheckedThrowingContinuation { continuation in
            guard let apiConfiguration = self.apiConfiguration else {
                return
            }

            continuation.resume(returning: apiConfiguration)
        }
    }

}
