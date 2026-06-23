//
//  MockConfigurationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `ConfigurationService` for use in tests.
///
/// Each method records the calls it receives and returns an injectable stubbed
/// result. By default a freshly-constructed mock returns sample data, so it can
/// be used with zero setup; inject a `Result` into the matching `*Result`
/// property to control the outcome of a method — assert on the value you
/// injected, not on the believable defaults.
///
/// The mock is safe to share across concurrent calls: its recorded state is
/// guarded by a lock.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class MockConfigurationService: ConfigurationService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var apiConfigurationCalls: [APIConfigurationCall] = []
        var apiConfigurationResult: Result<APIConfiguration, TMDbError> = .success(.sample)
        var countriesCalls: [CountriesCall] = []
        var countriesResult: Result<[Country], TMDbError> = .success(.samples)
        var jobsByDepartmentCalls: [JobsByDepartmentCall] = []
        var jobsByDepartmentResult: Result<[Department], TMDbError> = .success(.samples)
        var languagesCalls: [LanguagesCall] = []
        var languagesResult: Result<[Language], TMDbError> = .success(.samples)
        var primaryTranslationsCalls: [PrimaryTranslationsCall] = []
        var primaryTranslationsResult: Result<[String], TMDbError> = .success(.samples)
        var timezonesCalls: [TimezonesCall] = []
        var timezonesResult: Result<[Timezone], TMDbError> = .success(.samples)
    }

    ///
    /// Creates a mock configuration service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - apiConfiguration

    ///
    /// The arguments of a single call to ``apiConfiguration()``.
    ///
    public struct APIConfigurationCall: Sendable {}

    ///
    /// The recorded calls to ``apiConfiguration()``, in the order they were made.
    ///
    public var apiConfigurationCalls: [APIConfigurationCall] {
        withLock { storage.apiConfigurationCalls }
    }

    ///
    /// The stubbed result returned by ``apiConfiguration()``.
    ///
    public var apiConfigurationResult: Result<APIConfiguration, TMDbError> {
        get { withLock { storage.apiConfigurationResult } }
        set { withLock { storage.apiConfigurationResult = newValue } }
    }

    ///
    /// Records the call and returns ``apiConfigurationResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed API configuration.
    ///
    public func apiConfiguration() async throws(TMDbError) -> APIConfiguration {
        let result = withLock {
            storage.apiConfigurationCalls.append(APIConfigurationCall())
            return storage.apiConfigurationResult
        }

        return try result.get()
    }

    // MARK: - countries

    ///
    /// The arguments of a single call to ``countries(language:)``.
    ///
    public struct CountriesCall: Sendable {
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``countries(language:)``, in the order they were made.
    ///
    public var countriesCalls: [CountriesCall] {
        withLock { storage.countriesCalls }
    }

    ///
    /// The stubbed result returned by ``countries(language:)``.
    ///
    public var countriesResult: Result<[Country], TMDbError> {
        get { withLock { storage.countriesResult } }
        set { withLock { storage.countriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``countriesResult``.
    ///
    /// - Parameter language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of countries.
    ///
    public func countries(language: String?) async throws(TMDbError) -> [Country] {
        let result = withLock {
            storage.countriesCalls.append(CountriesCall(language: language))
            return storage.countriesResult
        }

        return try result.get()
    }

    // MARK: - jobsByDepartment

    ///
    /// The arguments of a single call to ``jobsByDepartment()``.
    ///
    public struct JobsByDepartmentCall: Sendable {}

    ///
    /// The recorded calls to ``jobsByDepartment()``, in the order they were made.
    ///
    public var jobsByDepartmentCalls: [JobsByDepartmentCall] {
        withLock { storage.jobsByDepartmentCalls }
    }

    ///
    /// The stubbed result returned by ``jobsByDepartment()``.
    ///
    public var jobsByDepartmentResult: Result<[Department], TMDbError> {
        get { withLock { storage.jobsByDepartmentResult } }
        set { withLock { storage.jobsByDepartmentResult = newValue } }
    }

    ///
    /// Records the call and returns ``jobsByDepartmentResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of departments.
    ///
    public func jobsByDepartment() async throws(TMDbError) -> [Department] {
        let result = withLock {
            storage.jobsByDepartmentCalls.append(JobsByDepartmentCall())
            return storage.jobsByDepartmentResult
        }

        return try result.get()
    }

    // MARK: - languages

    ///
    /// The arguments of a single call to ``languages()``.
    ///
    public struct LanguagesCall: Sendable {}

    ///
    /// The recorded calls to ``languages()``, in the order they were made.
    ///
    public var languagesCalls: [LanguagesCall] {
        withLock { storage.languagesCalls }
    }

    ///
    /// The stubbed result returned by ``languages()``.
    ///
    public var languagesResult: Result<[Language], TMDbError> {
        get { withLock { storage.languagesResult } }
        set { withLock { storage.languagesResult = newValue } }
    }

    ///
    /// Records the call and returns ``languagesResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of languages.
    ///
    public func languages() async throws(TMDbError) -> [Language] {
        let result = withLock {
            storage.languagesCalls.append(LanguagesCall())
            return storage.languagesResult
        }

        return try result.get()
    }

    // MARK: - primaryTranslations

    ///
    /// The arguments of a single call to ``primaryTranslations()``.
    ///
    public struct PrimaryTranslationsCall: Sendable {}

    ///
    /// The recorded calls to ``primaryTranslations()``, in the order they were made.
    ///
    public var primaryTranslationsCalls: [PrimaryTranslationsCall] {
        withLock { storage.primaryTranslationsCalls }
    }

    ///
    /// The stubbed result returned by ``primaryTranslations()``.
    ///
    public var primaryTranslationsResult: Result<[String], TMDbError> {
        get { withLock { storage.primaryTranslationsResult } }
        set { withLock { storage.primaryTranslationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``primaryTranslationsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of primary translations.
    ///
    public func primaryTranslations() async throws(TMDbError) -> [String] {
        let result = withLock {
            storage.primaryTranslationsCalls.append(PrimaryTranslationsCall())
            return storage.primaryTranslationsResult
        }

        return try result.get()
    }

    // MARK: - timezones

    ///
    /// The arguments of a single call to ``timezones()``.
    ///
    public struct TimezonesCall: Sendable {}

    ///
    /// The recorded calls to ``timezones()``, in the order they were made.
    ///
    public var timezonesCalls: [TimezonesCall] {
        withLock { storage.timezonesCalls }
    }

    ///
    /// The stubbed result returned by ``timezones()``.
    ///
    public var timezonesResult: Result<[Timezone], TMDbError> {
        get { withLock { storage.timezonesResult } }
        set { withLock { storage.timezonesResult = newValue } }
    }

    ///
    /// Records the call and returns ``timezonesResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed list of timezones.
    ///
    public func timezones() async throws(TMDbError) -> [Timezone] {
        let result = withLock {
            storage.timezonesCalls.append(TimezonesCall())
            return storage.timezonesResult
        }

        return try result.get()
    }

}
