@testable import TMDb
import XCTest

final class MockWatchProviderService: WatchProviderService {

    var countries: [Country]?

    func countries() async throws -> [Country] {
        try await withCheckedThrowingContinuation { continuation in
            guard let countries = self.countries else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: countries)
        }
    }

}
