@testable import TMDb
import XCTest

final class MockWatchProviderService: WatchProviderService {

    var countries: [Country]?
    var movieWatchProviders: [WatchProvider]?
    var tvShowWatchProviders: [WatchProvider]?

    func countries() async throws -> [Country] {
        try await withCheckedThrowingContinuation { continuation in
            guard let countries = self.countries else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: countries)
        }
    }

    func movieWatchProviders() async throws -> [WatchProvider] {
        try await withCheckedThrowingContinuation { continuation in
            guard let movieWatchProviders = self.movieWatchProviders else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: movieWatchProviders)
        }
    }

    func tvShowWatchProviders() async throws -> [WatchProvider] {
        try await withCheckedThrowingContinuation { continuation in
            guard let tvShowWatchProviders = self.tvShowWatchProviders else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: tvShowWatchProviders)
        }
    }

}
