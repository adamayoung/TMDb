//
//  TMDbConfigurationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbConfigurationService: ConfigurationService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func apiConfiguration() async throws -> APIConfiguration {
        let request = APIConfigurationRequest()

        let apiConfiguration: APIConfiguration
        do {
            apiConfiguration = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return apiConfiguration
    }

    func countries(language: String? = nil) async throws -> [Country] {
        let request = CountriesConfigurationRequest(language: language)

        let countries: [Country]
        do {
            countries = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return countries
    }

    func jobsByDepartment() async throws -> [Department] {
        let request = JobsConfigurationRequest()

        let departments: [Department]
        do {
            departments = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return departments
    }

    func languages() async throws -> [Language] {
        let request = LanguaguesConfigurationRequest()

        let languages: [Language]
        do {
            languages = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return languages
    }

}
