//
//  TMDbConfigurationServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .configuration))
struct TMDbConfigurationServiceTests {

    var service: TMDbConfigurationService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbConfigurationService(apiClient: apiClient)
    }

    @Test("apiConfiguration returns api configuration")
    func apiConfigurationReturnsAPIConfiguration() async throws {
        let expectedResult = APIConfiguration.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = APIConfigurationRequest()

        let result = try await service.apiConfiguration()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? APIConfigurationRequest == expectedRequest)
    }

    @Test("apiConfiguration when errors throws error")
    func apiConfigurationWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.apiConfiguration()
        }
    }

    @Test("countries with default parameter values returns countries")
    func countriesWithDefaultParameterValuesReturnsCountries() async throws {
        let expectedResult = [Country].mocks
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CountriesConfigurationRequest(language: nil)

        let result = try await (service as ConfigurationService).countries()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CountriesConfigurationRequest == expectedRequest)
    }

    @Test("countries with language returns countries")
    func countriesWithLanguageReturnsCountries() async throws {
        let expectedResult = [Country].mocks
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = CountriesConfigurationRequest(language: language)

        let result = try await service.countries(language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CountriesConfigurationRequest == expectedRequest)
    }

    @Test("countries when errors throws error")
    func countriesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.countries()
        }
    }

    @Test("jobsByDepartment returns departments")
    func jobsByDepartmentReturnsDepartments() async throws {
        let expectedResult = [Department].mocks
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = JobsConfigurationRequest()

        let result = try await service.jobsByDepartment()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? JobsConfigurationRequest == expectedRequest)
    }

    @Test("jobByDepartment when errors throws error")
    func jobsByDepartmentWhenErrorsThrows() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.jobsByDepartment()
        }
    }

    @Test("language returns languages")
    func languagesReturnsLanguages() async throws {
        let expectedResult = [Language].mocks
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = LanguaguesConfigurationRequest()

        let result = try await service.languages()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? LanguaguesConfigurationRequest == expectedRequest)
    }

    @Test("language when errors throws error")
    func languagesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.languages()
        }
    }

}
