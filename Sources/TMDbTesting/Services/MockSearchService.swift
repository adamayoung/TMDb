//
//  MockSearchService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length
import Foundation
import TMDb

///
/// A mock `SearchService` for use in tests.
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
public final class MockSearchService: SearchService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var searchAllCalls: [SearchAllCall] = []
        var searchAllResult: Result<MediaPageableList, TMDbError> = .success(.sample)
        var searchMoviesCalls: [SearchMoviesCall] = []
        var searchMoviesResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var searchTVSeriesCalls: [SearchTVSeriesCall] = []
        var searchTVSeriesResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var searchPeopleCalls: [SearchPeopleCall] = []
        var searchPeopleResult: Result<PersonPageableList, TMDbError> = .success(.sample)
        var searchCollectionsCalls: [SearchCollectionsCall] = []
        var searchCollectionsResult: Result<CollectionPageableList, TMDbError> = .success(.sample)
        var searchCompaniesCalls: [SearchCompaniesCall] = []
        var searchCompaniesResult: Result<CompanyPageableList, TMDbError> = .success(.sample)
        var searchKeywordsCalls: [SearchKeywordsCall] = []
        var searchKeywordsResult: Result<KeywordPageableList, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock search service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - searchAll

    ///
    /// The arguments of a single call to ``searchAll(query:filter:page:language:)``.
    ///
    public struct SearchAllCall: Sendable {
        ///
        /// The `query` argument the method was called with.
        ///
        public let query: String
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: AllMediaSearchFilter?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``searchAll(query:filter:page:language:)``,
    /// in the order they were made.
    ///
    public var searchAllCalls: [SearchAllCall] {
        withLock { storage.searchAllCalls }
    }

    ///
    /// The stubbed result returned by ``searchAll(query:filter:page:language:)``.
    ///
    public var searchAllResult: Result<MediaPageableList, TMDbError> {
        get { withLock { storage.searchAllResult } }
        set { withLock { storage.searchAllResult = newValue } }
    }

    ///
    /// Records the call and returns ``searchAllResult``.
    ///
    /// - Parameters:
    ///   - query: The query to search for.
    ///   - filter: Search filter parameters.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of media.
    ///
    public func searchAll(
        query: String,
        filter: AllMediaSearchFilter?,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MediaPageableList {
        let result = withLock {
            storage.searchAllCalls.append(
                SearchAllCall(
                    query: query,
                    filter: filter,
                    page: page,
                    language: language
                )
            )
            return storage.searchAllResult
        }

        return try result.get()
    }

    // MARK: - searchMovies

    ///
    /// The arguments of a single call to ``searchMovies(query:filter:page:language:)``.
    ///
    public struct SearchMoviesCall: Sendable {
        ///
        /// The `query` argument the method was called with.
        ///
        public let query: String
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: MovieSearchFilter?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``searchMovies(query:filter:page:language:)``,
    /// in the order they were made.
    ///
    public var searchMoviesCalls: [SearchMoviesCall] {
        withLock { storage.searchMoviesCalls }
    }

    ///
    /// The stubbed result returned by ``searchMovies(query:filter:page:language:)``.
    ///
    public var searchMoviesResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.searchMoviesResult } }
        set { withLock { storage.searchMoviesResult = newValue } }
    }

    ///
    /// Records the call and returns ``searchMoviesResult``.
    ///
    /// - Parameters:
    ///   - query: The query to search for.
    ///   - filter: Search filter parameters.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of movies.
    ///
    public func searchMovies(
        query: String,
        filter: MovieSearchFilter?,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.searchMoviesCalls.append(
                SearchMoviesCall(
                    query: query,
                    filter: filter,
                    page: page,
                    language: language
                )
            )
            return storage.searchMoviesResult
        }

        return try result.get()
    }

    // MARK: - searchTVSeries

    ///
    /// The arguments of a single call to ``searchTVSeries(query:filter:page:language:)``.
    ///
    public struct SearchTVSeriesCall: Sendable {
        ///
        /// The `query` argument the method was called with.
        ///
        public let query: String
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: TVSeriesSearchFilter?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``searchTVSeries(query:filter:page:language:)``,
    /// in the order they were made.
    ///
    public var searchTVSeriesCalls: [SearchTVSeriesCall] {
        withLock { storage.searchTVSeriesCalls }
    }

    ///
    /// The stubbed result returned by ``searchTVSeries(query:filter:page:language:)``.
    ///
    public var searchTVSeriesResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.searchTVSeriesResult } }
        set { withLock { storage.searchTVSeriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``searchTVSeriesResult``.
    ///
    /// - Parameters:
    ///   - query: The query to search for.
    ///   - filter: Search filter parameters.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of TV series.
    ///
    public func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter?,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.searchTVSeriesCalls.append(
                SearchTVSeriesCall(
                    query: query,
                    filter: filter,
                    page: page,
                    language: language
                )
            )
            return storage.searchTVSeriesResult
        }

        return try result.get()
    }

    // MARK: - searchPeople

    ///
    /// The arguments of a single call to ``searchPeople(query:filter:page:language:)``.
    ///
    public struct SearchPeopleCall: Sendable {
        ///
        /// The `query` argument the method was called with.
        ///
        public let query: String
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: PersonSearchFilter?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``searchPeople(query:filter:page:language:)``,
    /// in the order they were made.
    ///
    public var searchPeopleCalls: [SearchPeopleCall] {
        withLock { storage.searchPeopleCalls }
    }

    ///
    /// The stubbed result returned by ``searchPeople(query:filter:page:language:)``.
    ///
    public var searchPeopleResult: Result<PersonPageableList, TMDbError> {
        get { withLock { storage.searchPeopleResult } }
        set { withLock { storage.searchPeopleResult = newValue } }
    }

    ///
    /// Records the call and returns ``searchPeopleResult``.
    ///
    /// - Parameters:
    ///   - query: The query to search for.
    ///   - filter: Search filter parameters.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of people.
    ///
    public func searchPeople(
        query: String,
        filter: PersonSearchFilter?,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> PersonPageableList {
        let result = withLock {
            storage.searchPeopleCalls.append(
                SearchPeopleCall(
                    query: query,
                    filter: filter,
                    page: page,
                    language: language
                )
            )
            return storage.searchPeopleResult
        }

        return try result.get()
    }

    // MARK: - searchCollections

    ///
    /// The arguments of a single call to ``searchCollections(query:page:language:)``.
    ///
    public struct SearchCollectionsCall: Sendable {
        ///
        /// The `query` argument the method was called with.
        ///
        public let query: String
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``searchCollections(query:page:language:)``,
    /// in the order they were made.
    ///
    public var searchCollectionsCalls: [SearchCollectionsCall] {
        withLock { storage.searchCollectionsCalls }
    }

    ///
    /// The stubbed result returned by ``searchCollections(query:page:language:)``.
    ///
    public var searchCollectionsResult: Result<CollectionPageableList, TMDbError> {
        get { withLock { storage.searchCollectionsResult } }
        set { withLock { storage.searchCollectionsResult = newValue } }
    }

    ///
    /// Records the call and returns ``searchCollectionsResult``.
    ///
    /// - Parameters:
    ///   - query: The query to search for.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of collections.
    ///
    public func searchCollections(
        query: String,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> CollectionPageableList {
        let result = withLock {
            storage.searchCollectionsCalls.append(
                SearchCollectionsCall(
                    query: query,
                    page: page,
                    language: language
                )
            )
            return storage.searchCollectionsResult
        }

        return try result.get()
    }

    // MARK: - searchCompanies

    ///
    /// The arguments of a single call to ``searchCompanies(query:page:)``.
    ///
    public struct SearchCompaniesCall: Sendable {
        ///
        /// The `query` argument the method was called with.
        ///
        public let query: String
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``searchCompanies(query:page:)``, in the order they were made.
    ///
    public var searchCompaniesCalls: [SearchCompaniesCall] {
        withLock { storage.searchCompaniesCalls }
    }

    ///
    /// The stubbed result returned by ``searchCompanies(query:page:)``.
    ///
    public var searchCompaniesResult: Result<CompanyPageableList, TMDbError> {
        get { withLock { storage.searchCompaniesResult } }
        set { withLock { storage.searchCompaniesResult = newValue } }
    }

    ///
    /// Records the call and returns ``searchCompaniesResult``.
    ///
    /// - Parameters:
    ///   - query: The query to search for.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of companies.
    ///
    public func searchCompanies(
        query: String,
        page: Int?
    ) async throws(TMDbError) -> CompanyPageableList {
        let result = withLock {
            storage.searchCompaniesCalls.append(
                SearchCompaniesCall(
                    query: query,
                    page: page
                )
            )
            return storage.searchCompaniesResult
        }

        return try result.get()
    }

    // MARK: - searchKeywords

    ///
    /// The arguments of a single call to ``searchKeywords(query:page:)``.
    ///
    public struct SearchKeywordsCall: Sendable {
        ///
        /// The `query` argument the method was called with.
        ///
        public let query: String
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``searchKeywords(query:page:)``, in the order they were made.
    ///
    public var searchKeywordsCalls: [SearchKeywordsCall] {
        withLock { storage.searchKeywordsCalls }
    }

    ///
    /// The stubbed result returned by ``searchKeywords(query:page:)``.
    ///
    public var searchKeywordsResult: Result<KeywordPageableList, TMDbError> {
        get { withLock { storage.searchKeywordsResult } }
        set { withLock { storage.searchKeywordsResult = newValue } }
    }

    ///
    /// Records the call and returns ``searchKeywordsResult``.
    ///
    /// - Parameters:
    ///   - query: The query to search for.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of keywords.
    ///
    public func searchKeywords(
        query: String,
        page: Int?
    ) async throws(TMDbError) -> KeywordPageableList {
        let result = withLock {
            storage.searchKeywordsCalls.append(
                SearchKeywordsCall(
                    query: query,
                    page: page
                )
            )
            return storage.searchKeywordsResult
        }

        return try result.get()
    }

}
