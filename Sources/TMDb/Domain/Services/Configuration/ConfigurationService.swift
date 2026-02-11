//
//  ConfigurationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining configuration data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol ConfigurationService: Sendable {

    ///
    /// Returns the TMDb API system wide configuration information.
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
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
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

    ///
    /// Returns a list of the officially supported translations on TMDb.
    ///
    /// [TMDb API - Configuration: Primary
    /// Translations](https://developer.themoviedb.org/reference/configuration-primary-translations)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Primary translations used throughout TMDb.
    ///
    func primaryTranslations() async throws -> [String]

    ///
    /// Returns the list of timezones used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Timezones](https://developer.themoviedb.org/reference/configuration-timezones)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Timezones used throughout TMDb.
    ///
    func timezones() async throws -> [Timezone]

}

public extension ConfigurationService {

    ///
    /// Returns the list of countries used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Countries](https://developer.themoviedb.org/reference/configuration-countries)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Countries used throughout TMDb,
    ///
    func countries(language: String? = nil) async throws -> [Country] {
        try await countries(language: language)
    }

}
