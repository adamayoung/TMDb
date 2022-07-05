@testable import TMDb
import XCTest

final class MockConfigurationService: ConfigurationService {

    var apiConfiguration: APIConfiguration?
    var countries: [Country]?
    var departments: [Department]?

    func apiConfiguration() async throws -> APIConfiguration {
        try await withCheckedThrowingContinuation { continuation in
            guard let apiConfiguration = self.apiConfiguration else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: apiConfiguration)
        }
    }

    func countries() async throws -> [Country] {
        try await withCheckedThrowingContinuation { continuation in
            guard let countries = self.countries else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: countries)
        }
    }

    func jobsByDepartment() async throws -> [Department] {
        try await withCheckedThrowingContinuation { continuation in
            guard let departments = self.departments else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: departments)
        }
    }

}
