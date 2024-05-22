//
//  TMDbConfigurationService.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
