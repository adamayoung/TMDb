//
//  MockNaturalLanguageSearchService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `NaturalLanguageSearchService` for use in tests.
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
public final class MockNaturalLanguageSearchService: NaturalLanguageSearchService,
@unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var availability = NaturalLanguageSearchAvailability.sample
        var planCalls: [PlanCall] = []
        var planResult: Result<SearchPlan, NaturalLanguageSearchError> = .success(.sample)
        var searchCalls: [SearchCall] = []
        var searchResult: Result<NaturalLanguageSearchResult, NaturalLanguageSearchError> =
            .success(.sample)
    }

    ///
    /// Creates a mock natural language search service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - availability

    ///
    /// The stubbed availability of the natural language search capability.
    ///
    public var availability: NaturalLanguageSearchAvailability {
        get { withLock { storage.availability } }
        set { withLock { storage.availability = newValue } }
    }

    // MARK: - plan

    ///
    /// The arguments of a single call to ``plan(for:)``.
    ///
    public struct PlanCall: Sendable {
        ///
        /// The `for` argument the method was called with.
        ///
        public let prompt: String
    }

    ///
    /// The recorded calls to ``plan(for:)``, in the order they were made.
    ///
    public var planCalls: [PlanCall] {
        withLock { storage.planCalls }
    }

    ///
    /// The stubbed result returned by ``plan(for:)``.
    ///
    public var planResult: Result<SearchPlan, NaturalLanguageSearchError> {
        get { withLock { storage.planResult } }
        set { withLock { storage.planResult = newValue } }
    }

    ///
    /// Records the call and returns ``planResult``.
    ///
    /// - Parameter prompt: The free-text prompt to plan a search for.
    ///
    /// - Throws: Natural language search error `NaturalLanguageSearchError`.
    ///
    /// - Returns: The stubbed search plan.
    ///
    public func plan(for prompt: String) async throws(NaturalLanguageSearchError) -> SearchPlan {
        let result = withLock {
            storage.planCalls.append(PlanCall(prompt: prompt))
            return storage.planResult
        }

        return try result.get()
    }

    // MARK: - search

    ///
    /// The arguments of a single call to ``search(matching:)``.
    ///
    public struct SearchCall: Sendable {
        ///
        /// The `matching` argument the method was called with.
        ///
        public let prompt: String
    }

    ///
    /// The recorded calls to ``search(matching:)``, in the order they were made.
    ///
    public var searchCalls: [SearchCall] {
        withLock { storage.searchCalls }
    }

    ///
    /// The stubbed result returned by ``search(matching:)``.
    ///
    public var searchResult: Result<NaturalLanguageSearchResult, NaturalLanguageSearchError> {
        get { withLock { storage.searchResult } }
        set { withLock { storage.searchResult = newValue } }
    }

    ///
    /// Records the call and returns ``searchResult``.
    ///
    /// - Parameter prompt: The free-text prompt to search with.
    ///
    /// - Throws: Natural language search error `NaturalLanguageSearchError`.
    ///
    /// - Returns: The stubbed natural language search result.
    ///
    public func search(
        matching prompt: String
    ) async throws(NaturalLanguageSearchError) -> NaturalLanguageSearchResult {
        let result = withLock {
            storage.searchCalls.append(SearchCall(prompt: prompt))
            return storage.searchResult
        }

        return try result.get()
    }

}
