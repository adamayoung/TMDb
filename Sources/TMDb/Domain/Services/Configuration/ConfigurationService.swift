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
public protocol ConfigurationService: Sendable {

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
    func apiConfiguration() async throws -> APIConfiguration

    ///
    /// Returns the list of countries used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Countries](https://developer.themoviedb.org/reference/configuration-countries)
    ///
    /// - Parameters:
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Countries used throughout TMDb,
    ///
    func countries(language: String?) async throws -> [Country]

    ///
    /// Returns a list of the jobs and departments used on TMDb.
    ///
    /// [TMDb API - Configuration: Jobs](https://developer.themoviedb.org/reference/configuration-jobs)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Jobs and departments used on TMDb.
    ///
    func jobsByDepartment() async throws -> [Department]
    ///
    /// Returns the list of languages (ISO 639-1 tags) used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Languages](https://developer.themoviedb.org/reference/configuration-languages)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Languages used throughout TMDb.
    ///
    func languages() async throws -> [Language]

}

extension ConfigurationService {

    public func countries(language: String? = nil) async throws -> [Country] {
        try await countries(language: language)
    }

}
