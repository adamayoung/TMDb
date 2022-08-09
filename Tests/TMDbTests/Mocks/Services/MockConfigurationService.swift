@testable import TMDb
import XCTest

final class MockConfigurationService: ConfigurationService {

    var apiConfiguration: APIConfiguration?
    var countries: [Country]?
    var departments: [Department]?
    var languages: [Language]?

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

    func languages() async throws -> [Language] {
        try await withCheckedThrowingContinuation { continuation in
            guard let languages = self.languages else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: languages)
        }
    }

}
