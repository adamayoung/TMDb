//
//  ConfigurationService.swift
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

///
/// Provides an interface for obtaining configuration data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class ConfigurationService {

    private let apiClient: any APIClient

    ///
    /// Creates a configuration service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns the TMDb API system wide configuration information. The result is cached, so there is no overhead in
    /// making multiple calls.
    ///
    /// [TMDb API - Configuration: Details](https://developer.themoviedb.org/reference/configuration-details)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The API configuration.
    ///
    public func apiConfiguration() async throws -> APIConfiguration {
        let apiConfiguration: APIConfiguration
        do {
            apiConfiguration = try await apiClient.get(endpoint: ConfigurationEndpoint.api)
        } catch let error {
            throw TMDbError(error: error)
        }

        return apiConfiguration
    }

    ///
    /// Returns the list of countries used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Countries](https://developer.themoviedb.org/reference/configuration-countries)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Countries used throughout TMDb,
    ///
    public func countries() async throws -> [Country] {
        let countries: [Country]
        do {
            countries = try await apiClient.get(endpoint: ConfigurationEndpoint.countries)
        } catch let error {
            throw TMDbError(error: error)
        }

        return countries
    }

    ///
    /// Returns a list of the jobs and departments used on TMDb.
    ///
    /// [TMDb API - Configuration: Jobs](https://developer.themoviedb.org/reference/configuration-jobs)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Jobs and departments used on TMDb.
    ///
    public func jobsByDepartment() async throws -> [Department] {
        let departments: [Department]
        do {
            departments = try await apiClient.get(endpoint: ConfigurationEndpoint.jobs)
        } catch let error {
            throw TMDbError(error: error)
        }

        return departments
    }

    ///
    /// Returns the list of languages (ISO 639-1 tags) used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Languages](https://developer.themoviedb.org/reference/configuration-languages)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Languages used throughout TMDb.
    ///
    public func languages() async throws -> [Language] {
        let languages: [Language]
        do {
            languages = try await apiClient.get(endpoint: ConfigurationEndpoint.languages)
        } catch let error {
            throw TMDbError(error: error)
        }

        return languages
    }

}
