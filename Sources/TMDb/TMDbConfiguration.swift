//
//  TMDbConfiguration.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Configuration options for the TMDb client.
///
/// Use this struct to set default language and country values that will be applied
/// to API requests when explicit values are not provided.
///
/// ```swift
/// let configuration = TMDbConfiguration(
///     defaultLanguage: "es-ES",
///     defaultCountry: "ES"
/// )
/// let client = TMDbClient(apiKey: "your-api-key", configuration: configuration)
/// ```
///
public struct TMDbConfiguration: Sendable, Equatable {

    ///
    /// The default ISO 639-1 language code to use for API requests.
    ///
    /// When set, this value will be used as the default language parameter
    /// for methods that accept a language parameter, unless an explicit
    /// language is provided.
    ///
    /// Example values: `"en"`, `"es"`, `"fr"`, `"de"`.
    ///
    public let defaultLanguage: String?

    ///
    /// The default ISO 3166-1 country code to use for API requests.
    ///
    /// When set, this value will be used as the default country parameter
    /// for methods that accept a country parameter, unless an explicit
    /// country is provided.
    ///
    /// Example values: `"US"`, `"GB"`, `"ES"`, `"DE"`.
    ///
    public let defaultCountry: String?

    ///
    /// The retry configuration for automatic retry with exponential backoff.
    ///
    /// When set, transient HTTP errors such as rate limiting (HTTP 429) and
    /// server errors (HTTP 5xx) will be automatically retried according to
    /// the provided configuration.
    ///
    /// When `nil` (the default), no automatic retry is performed.
    ///
    /// ```swift
    /// let configuration = TMDbConfiguration(
    ///     retry: .default
    /// )
    /// ```
    ///
    public let retry: RetryConfiguration?

    ///
    /// Creates a TMDb configuration with optional default language, country, and retry settings.
    ///
    /// - Parameters:
    ///   - defaultLanguage: The default ISO 639-1 language code. Defaults to `nil`.
    ///   - defaultCountry: The default ISO 3166-1 country code. Defaults to `nil`.
    ///   - retry: The retry configuration for automatic retry. Defaults to `nil` (no retry).
    ///
    public init(
        defaultLanguage: String? = nil,
        defaultCountry: String? = nil,
        retry: RetryConfiguration? = nil
    ) {
        self.defaultLanguage = defaultLanguage
        self.defaultCountry = defaultCountry
        self.retry = retry
    }

    ///
    /// The default configuration with no language or country defaults set.
    ///
    public static let `default` = TMDbConfiguration()

    ///
    /// A configuration using the system's current language and country settings.
    ///
    /// Uses `Locale.current` to detect:
    /// - Language: `Locale.current.language.minimalIdentifier` - returns the minimal BCP-47
    ///   identifier (e.g., "en", "es", "zh-Hans", "zh-Hant"). May include script subtag for
    ///   languages that require disambiguation.
    /// - Country: `Locale.current.region?.identifier` (e.g., "US", "GB"). Returns `nil` if
    ///   the system locale has no region configured.
    ///
    public static var system: TMDbConfiguration {
        TMDbConfiguration(
            defaultLanguage: Locale.current.language.minimalIdentifier,
            defaultCountry: Locale.current.region?.identifier
        )
    }

}
