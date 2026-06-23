//
//  MockChangesService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length
import Foundation
import TMDb

///
/// A mock `ChangesService` for use in tests.
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
public final class MockChangesService: ChangesService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var movieChangesCalls: [MovieChangesCall] = []
        var movieChangesResult: Result<ChangedIDCollection, TMDbError> = .success(.sample)
        var tvSeriesChangesCalls: [TVSeriesChangesCall] = []
        var tvSeriesChangesResult: Result<ChangedIDCollection, TMDbError> = .success(.sample)
        var personChangesCalls: [PersonChangesCall] = []
        var personChangesResult: Result<ChangedIDCollection, TMDbError> = .success(.sample)
        var movieDetailsCalls: [MovieDetailsCall] = []
        var movieDetailsResult: Result<ChangeCollection, TMDbError> = .success(.sample)
        var tvSeriesDetailsCalls: [TVSeriesDetailsCall] = []
        var tvSeriesDetailsResult: Result<ChangeCollection, TMDbError> = .success(.sample)
        var personDetailsCalls: [PersonDetailsCall] = []
        var personDetailsResult: Result<ChangeCollection, TMDbError> = .success(.sample)
        var tvSeasonDetailsCalls: [TVSeasonDetailsCall] = []
        var tvSeasonDetailsResult: Result<ChangeCollection, TMDbError> = .success(.sample)
        var tvEpisodeDetailsCalls: [TVEpisodeDetailsCall] = []
        var tvEpisodeDetailsResult: Result<ChangeCollection, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock changes service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - movieChanges

    ///
    /// The arguments of a single call to ``movieChanges(startDate:endDate:page:)``.
    ///
    public struct MovieChangesCall: Sendable {
        ///
        /// The `startDate` argument the method was called with.
        ///
        public let startDate: Date?
        ///
        /// The `endDate` argument the method was called with.
        ///
        public let endDate: Date?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``movieChanges(startDate:endDate:page:)``, in the order they
    /// were made.
    ///
    public var movieChangesCalls: [MovieChangesCall] {
        withLock { storage.movieChangesCalls }
    }

    ///
    /// The stubbed result returned by ``movieChanges(startDate:endDate:page:)``.
    ///
    public var movieChangesResult: Result<ChangedIDCollection, TMDbError> {
        get { withLock { storage.movieChangesResult } }
        set { withLock { storage.movieChangesResult = newValue } }
    }

    ///
    /// Records the call and returns ``movieChangesResult``.
    ///
    /// - Parameters:
    ///   - startDate: The start date of the range to retrieve changes for.
    ///   - endDate: The end date of the range to retrieve changes for.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of changed identifiers.
    ///
    public func movieChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        let result = withLock {
            storage.movieChangesCalls.append(
                MovieChangesCall(startDate: startDate, endDate: endDate, page: page)
            )
            return storage.movieChangesResult
        }

        return try result.get()
    }

    // MARK: - tvSeriesChanges

    ///
    /// The arguments of a single call to ``tvSeriesChanges(startDate:endDate:page:)``.
    ///
    public struct TVSeriesChangesCall: Sendable {
        ///
        /// The `startDate` argument the method was called with.
        ///
        public let startDate: Date?
        ///
        /// The `endDate` argument the method was called with.
        ///
        public let endDate: Date?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``tvSeriesChanges(startDate:endDate:page:)``, in the order they
    /// were made.
    ///
    public var tvSeriesChangesCalls: [TVSeriesChangesCall] {
        withLock { storage.tvSeriesChangesCalls }
    }

    ///
    /// The stubbed result returned by ``tvSeriesChanges(startDate:endDate:page:)``.
    ///
    public var tvSeriesChangesResult: Result<ChangedIDCollection, TMDbError> {
        get { withLock { storage.tvSeriesChangesResult } }
        set { withLock { storage.tvSeriesChangesResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvSeriesChangesResult``.
    ///
    /// - Parameters:
    ///   - startDate: The start date of the range to retrieve changes for.
    ///   - endDate: The end date of the range to retrieve changes for.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of changed identifiers.
    ///
    public func tvSeriesChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        let result = withLock {
            storage.tvSeriesChangesCalls.append(
                TVSeriesChangesCall(startDate: startDate, endDate: endDate, page: page)
            )
            return storage.tvSeriesChangesResult
        }

        return try result.get()
    }

    // MARK: - personChanges

    ///
    /// The arguments of a single call to ``personChanges(startDate:endDate:page:)``.
    ///
    public struct PersonChangesCall: Sendable {
        ///
        /// The `startDate` argument the method was called with.
        ///
        public let startDate: Date?
        ///
        /// The `endDate` argument the method was called with.
        ///
        public let endDate: Date?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``personChanges(startDate:endDate:page:)``, in the order they
    /// were made.
    ///
    public var personChangesCalls: [PersonChangesCall] {
        withLock { storage.personChangesCalls }
    }

    ///
    /// The stubbed result returned by ``personChanges(startDate:endDate:page:)``.
    ///
    public var personChangesResult: Result<ChangedIDCollection, TMDbError> {
        get { withLock { storage.personChangesResult } }
        set { withLock { storage.personChangesResult = newValue } }
    }

    ///
    /// Records the call and returns ``personChangesResult``.
    ///
    /// - Parameters:
    ///   - startDate: The start date of the range to retrieve changes for.
    ///   - endDate: The end date of the range to retrieve changes for.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of changed identifiers.
    ///
    public func personChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        let result = withLock {
            storage.personChangesCalls.append(
                PersonChangesCall(startDate: startDate, endDate: endDate, page: page)
            )
            return storage.personChangesResult
        }

        return try result.get()
    }

    // MARK: - movieDetails

    ///
    /// The arguments of a single call to ``movieDetails(forMovie:startDate:endDate:page:)``.
    ///
    public struct MovieDetailsCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: Movie.ID
        ///
        /// The `startDate` argument the method was called with.
        ///
        public let startDate: Date?
        ///
        /// The `endDate` argument the method was called with.
        ///
        public let endDate: Date?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``movieDetails(forMovie:startDate:endDate:page:)``, in the
    /// order they were made.
    ///
    public var movieDetailsCalls: [MovieDetailsCall] {
        withLock { storage.movieDetailsCalls }
    }

    ///
    /// The stubbed result returned by ``movieDetails(forMovie:startDate:endDate:page:)``.
    ///
    public var movieDetailsResult: Result<ChangeCollection, TMDbError> {
        get { withLock { storage.movieDetailsResult } }
        set { withLock { storage.movieDetailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``movieDetailsResult``.
    ///
    /// - Parameters:
    ///   - id: The identifier of the movie.
    ///   - startDate: The start date of the range to retrieve changes for.
    ///   - endDate: The end date of the range to retrieve changes for.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of changes.
    ///
    public func movieDetails(
        forMovie id: Movie.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let result = withLock {
            storage.movieDetailsCalls.append(
                MovieDetailsCall(id: id, startDate: startDate, endDate: endDate, page: page)
            )
            return storage.movieDetailsResult
        }

        return try result.get()
    }

    // MARK: - tvSeriesDetails

    ///
    /// The arguments of a single call to
    /// ``tvSeriesDetails(forTVSeries:startDate:endDate:page:)``.
    ///
    public struct TVSeriesDetailsCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: TVSeries.ID
        ///
        /// The `startDate` argument the method was called with.
        ///
        public let startDate: Date?
        ///
        /// The `endDate` argument the method was called with.
        ///
        public let endDate: Date?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``tvSeriesDetails(forTVSeries:startDate:endDate:page:)``, in
    /// the order they were made.
    ///
    public var tvSeriesDetailsCalls: [TVSeriesDetailsCall] {
        withLock { storage.tvSeriesDetailsCalls }
    }

    ///
    /// The stubbed result returned by
    /// ``tvSeriesDetails(forTVSeries:startDate:endDate:page:)``.
    ///
    public var tvSeriesDetailsResult: Result<ChangeCollection, TMDbError> {
        get { withLock { storage.tvSeriesDetailsResult } }
        set { withLock { storage.tvSeriesDetailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvSeriesDetailsResult``.
    ///
    /// - Parameters:
    ///   - id: The identifier of the TV series.
    ///   - startDate: The start date of the range to retrieve changes for.
    ///   - endDate: The end date of the range to retrieve changes for.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of changes.
    ///
    public func tvSeriesDetails(
        forTVSeries id: TVSeries.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let result = withLock {
            storage.tvSeriesDetailsCalls.append(
                TVSeriesDetailsCall(id: id, startDate: startDate, endDate: endDate, page: page)
            )
            return storage.tvSeriesDetailsResult
        }

        return try result.get()
    }

    // MARK: - personDetails

    ///
    /// The arguments of a single call to
    /// ``personDetails(forPerson:startDate:endDate:page:)``.
    ///
    public struct PersonDetailsCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: Person.ID
        ///
        /// The `startDate` argument the method was called with.
        ///
        public let startDate: Date?
        ///
        /// The `endDate` argument the method was called with.
        ///
        public let endDate: Date?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``personDetails(forPerson:startDate:endDate:page:)``, in the
    /// order they were made.
    ///
    public var personDetailsCalls: [PersonDetailsCall] {
        withLock { storage.personDetailsCalls }
    }

    ///
    /// The stubbed result returned by ``personDetails(forPerson:startDate:endDate:page:)``.
    ///
    public var personDetailsResult: Result<ChangeCollection, TMDbError> {
        get { withLock { storage.personDetailsResult } }
        set { withLock { storage.personDetailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``personDetailsResult``.
    ///
    /// - Parameters:
    ///   - id: The identifier of the person.
    ///   - startDate: The start date of the range to retrieve changes for.
    ///   - endDate: The end date of the range to retrieve changes for.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of changes.
    ///
    public func personDetails(
        forPerson id: Person.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let result = withLock {
            storage.personDetailsCalls.append(
                PersonDetailsCall(id: id, startDate: startDate, endDate: endDate, page: page)
            )
            return storage.personDetailsResult
        }

        return try result.get()
    }

    // MARK: - tvSeasonDetails

    ///
    /// The arguments of a single call to
    /// ``tvSeasonDetails(forSeason:startDate:endDate:page:)``.
    ///
    public struct TVSeasonDetailsCall: Sendable {
        ///
        /// The `seasonID` argument the method was called with.
        ///
        public let seasonID: Int
        ///
        /// The `startDate` argument the method was called with.
        ///
        public let startDate: Date?
        ///
        /// The `endDate` argument the method was called with.
        ///
        public let endDate: Date?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``tvSeasonDetails(forSeason:startDate:endDate:page:)``, in the
    /// order they were made.
    ///
    public var tvSeasonDetailsCalls: [TVSeasonDetailsCall] {
        withLock { storage.tvSeasonDetailsCalls }
    }

    ///
    /// The stubbed result returned by ``tvSeasonDetails(forSeason:startDate:endDate:page:)``.
    ///
    public var tvSeasonDetailsResult: Result<ChangeCollection, TMDbError> {
        get { withLock { storage.tvSeasonDetailsResult } }
        set { withLock { storage.tvSeasonDetailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvSeasonDetailsResult``.
    ///
    /// - Parameters:
    ///   - seasonID: The identifier of the TV season.
    ///   - startDate: The start date of the range to retrieve changes for.
    ///   - endDate: The end date of the range to retrieve changes for.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of changes.
    ///
    public func tvSeasonDetails(
        forSeason seasonID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let result = withLock {
            storage.tvSeasonDetailsCalls.append(
                TVSeasonDetailsCall(
                    seasonID: seasonID,
                    startDate: startDate,
                    endDate: endDate,
                    page: page
                )
            )
            return storage.tvSeasonDetailsResult
        }

        return try result.get()
    }

    // MARK: - tvEpisodeDetails

    ///
    /// The arguments of a single call to
    /// ``tvEpisodeDetails(forEpisode:startDate:endDate:page:)``.
    ///
    public struct TVEpisodeDetailsCall: Sendable {
        ///
        /// The `episodeID` argument the method was called with.
        ///
        public let episodeID: Int
        ///
        /// The `startDate` argument the method was called with.
        ///
        public let startDate: Date?
        ///
        /// The `endDate` argument the method was called with.
        ///
        public let endDate: Date?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``tvEpisodeDetails(forEpisode:startDate:endDate:page:)``, in
    /// the order they were made.
    ///
    public var tvEpisodeDetailsCalls: [TVEpisodeDetailsCall] {
        withLock { storage.tvEpisodeDetailsCalls }
    }

    ///
    /// The stubbed result returned by
    /// ``tvEpisodeDetails(forEpisode:startDate:endDate:page:)``.
    ///
    public var tvEpisodeDetailsResult: Result<ChangeCollection, TMDbError> {
        get { withLock { storage.tvEpisodeDetailsResult } }
        set { withLock { storage.tvEpisodeDetailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvEpisodeDetailsResult``.
    ///
    /// - Parameters:
    ///   - episodeID: The identifier of the TV episode.
    ///   - startDate: The start date of the range to retrieve changes for.
    ///   - endDate: The end date of the range to retrieve changes for.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of changes.
    ///
    public func tvEpisodeDetails(
        forEpisode episodeID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let result = withLock {
            storage.tvEpisodeDetailsCalls.append(
                TVEpisodeDetailsCall(
                    episodeID: episodeID,
                    startDate: startDate,
                    endDate: endDate,
                    page: page
                )
            )
            return storage.tvEpisodeDetailsResult
        }

        return try result.get()
    }

}
