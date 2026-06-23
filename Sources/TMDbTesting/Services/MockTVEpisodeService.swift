//
//  MockTVEpisodeService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length type_body_length
import Foundation
import TMDb

///
/// A mock `TVEpisodeService` for use in tests.
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
public final class MockTVEpisodeService: TVEpisodeService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<TVEpisode, TMDbError> = .success(.sample)
        var detailsAppendingCalls: [DetailsAppendingCall] = []
        var detailsAppendingResult: Result<TVEpisodeDetailsResponse, TMDbError> = .success(.sample)
        var creditsCalls: [CreditsCall] = []
        var creditsResult: Result<ShowCredits, TMDbError> = .success(.sample)
        var imagesCalls: [ImagesCall] = []
        var imagesResult: Result<TVEpisodeImageCollection, TMDbError> = .success(.sample)
        var videosCalls: [VideosCall] = []
        var videosResult: Result<VideoCollection, TMDbError> = .success(.sample)
        var accountStatesCalls: [AccountStatesCall] = []
        var accountStatesResult: Result<AccountStates, TMDbError> = .success(.sample)
        var addRatingCalls: [AddRatingCall] = []
        var addRatingResult: Result<Void, TMDbError> = .success(())
        var deleteRatingCalls: [DeleteRatingCall] = []
        var deleteRatingResult: Result<Void, TMDbError> = .success(())
        var externalLinksCalls: [ExternalLinksCall] = []
        var externalLinksResult: Result<TVEpisodeExternalLinksCollection, TMDbError> =
            .success(.sample)
        var translationsCalls: [TranslationsCall] = []
        var translationsResult: Result<TranslationCollection<TVEpisodeTranslationData>, TMDbError> =
            .success(.sample)
        var changesCalls: [ChangesCall] = []
        var changesResult: Result<ChangeCollection, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock TV episode service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to
    /// ``details(forEpisode:inSeason:inTVSeries:language:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `episodeNumber` argument the method was called with.
        ///
        public let episodeNumber: Int
        ///
        /// The `seasonNumber` argument the method was called with.
        ///
        public let seasonNumber: Int
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``details(forEpisode:inSeason:inTVSeries:language:)``, in the order
    /// they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forEpisode:inSeason:inTVSeries:language:)``.
    ///
    public var detailsResult: Result<TVEpisode, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number.
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed TV episode.
    ///
    public func details(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> TVEpisode {
        let result = withLock {
            storage.detailsCalls.append(
                DetailsCall(
                    episodeNumber: episodeNumber,
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID,
                    language: language
                )
            )
            return storage.detailsResult
        }

        return try result.get()
    }

    // MARK: - detailsAppending

    ///
    /// The arguments of a single call to
    /// ``details(forEpisode:inSeason:inTVSeries:appending:language:)``.
    ///
    public struct DetailsAppendingCall: Sendable {
        ///
        /// The `episodeNumber` argument the method was called with.
        ///
        public let episodeNumber: Int
        ///
        /// The `seasonNumber` argument the method was called with.
        ///
        public let seasonNumber: Int
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `appending` argument the method was called with.
        ///
        public let appending: TVEpisodeAppendOption
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``details(forEpisode:inSeason:inTVSeries:appending:language:)``, in
    /// the order they were made.
    ///
    public var detailsAppendingCalls: [DetailsAppendingCall] {
        withLock { storage.detailsAppendingCalls }
    }

    ///
    /// The stubbed result returned by
    /// ``details(forEpisode:inSeason:inTVSeries:appending:language:)``.
    ///
    public var detailsAppendingResult: Result<TVEpisodeDetailsResponse, TMDbError> {
        get { withLock { storage.detailsAppendingResult } }
        set { withLock { storage.detailsAppendingResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsAppendingResult``.
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number.
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - appending: The additional data to append to the response.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed TV episode details response.
    ///
    public func details(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        appending: TVEpisodeAppendOption,
        language: String?
    ) async throws(TMDbError) -> TVEpisodeDetailsResponse {
        let result = withLock {
            storage.detailsAppendingCalls.append(
                DetailsAppendingCall(
                    episodeNumber: episodeNumber,
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID,
                    appending: appending,
                    language: language
                )
            )
            return storage.detailsAppendingResult
        }

        return try result.get()
    }

    // MARK: - credits

    ///
    /// The arguments of a single call to
    /// ``credits(forEpisode:inSeason:inTVSeries:language:)``.
    ///
    public struct CreditsCall: Sendable {
        ///
        /// The `episodeNumber` argument the method was called with.
        ///
        public let episodeNumber: Int
        ///
        /// The `seasonNumber` argument the method was called with.
        ///
        public let seasonNumber: Int
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``credits(forEpisode:inSeason:inTVSeries:language:)``, in the order
    /// they were made.
    ///
    public var creditsCalls: [CreditsCall] {
        withLock { storage.creditsCalls }
    }

    ///
    /// The stubbed result returned by ``credits(forEpisode:inSeason:inTVSeries:language:)``.
    ///
    public var creditsResult: Result<ShowCredits, TMDbError> {
        get { withLock { storage.creditsResult } }
        set { withLock { storage.creditsResult = newValue } }
    }

    ///
    /// Records the call and returns ``creditsResult``.
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number.
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed show credits.
    ///
    public func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> ShowCredits {
        let result = withLock {
            storage.creditsCalls.append(
                CreditsCall(
                    episodeNumber: episodeNumber,
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID,
                    language: language
                )
            )
            return storage.creditsResult
        }

        return try result.get()
    }

    // MARK: - images

    ///
    /// The arguments of a single call to
    /// ``images(forEpisode:inSeason:inTVSeries:filter:)``.
    ///
    public struct ImagesCall: Sendable {
        ///
        /// The `episodeNumber` argument the method was called with.
        ///
        public let episodeNumber: Int
        ///
        /// The `seasonNumber` argument the method was called with.
        ///
        public let seasonNumber: Int
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: TVEpisodeImageFilter?
    }

    ///
    /// The recorded calls to ``images(forEpisode:inSeason:inTVSeries:filter:)``, in the order they
    /// were made.
    ///
    public var imagesCalls: [ImagesCall] {
        withLock { storage.imagesCalls }
    }

    ///
    /// The stubbed result returned by ``images(forEpisode:inSeason:inTVSeries:filter:)``.
    ///
    public var imagesResult: Result<TVEpisodeImageCollection, TMDbError> {
        get { withLock { storage.imagesResult } }
        set { withLock { storage.imagesResult = newValue } }
    }

    ///
    /// Records the call and returns ``imagesResult``.
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number.
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - filter: Filter to narrow the images returned.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed TV episode image collection.
    ///
    public func images(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVEpisodeImageFilter?
    ) async throws(TMDbError) -> TVEpisodeImageCollection {
        let result = withLock {
            storage.imagesCalls.append(
                ImagesCall(
                    episodeNumber: episodeNumber,
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID,
                    filter: filter
                )
            )
            return storage.imagesResult
        }

        return try result.get()
    }

    // MARK: - videos

    ///
    /// The arguments of a single call to
    /// ``videos(forEpisode:inSeason:inTVSeries:filter:)``.
    ///
    public struct VideosCall: Sendable {
        ///
        /// The `episodeNumber` argument the method was called with.
        ///
        public let episodeNumber: Int
        ///
        /// The `seasonNumber` argument the method was called with.
        ///
        public let seasonNumber: Int
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: TVEpisodeVideoFilter?
    }

    ///
    /// The recorded calls to ``videos(forEpisode:inSeason:inTVSeries:filter:)``, in the order they
    /// were made.
    ///
    public var videosCalls: [VideosCall] {
        withLock { storage.videosCalls }
    }

    ///
    /// The stubbed result returned by ``videos(forEpisode:inSeason:inTVSeries:filter:)``.
    ///
    public var videosResult: Result<VideoCollection, TMDbError> {
        get { withLock { storage.videosResult } }
        set { withLock { storage.videosResult = newValue } }
    }

    ///
    /// Records the call and returns ``videosResult``.
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number.
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - filter: Filter to narrow the videos returned.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed video collection.
    ///
    public func videos(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVEpisodeVideoFilter?
    ) async throws(TMDbError) -> VideoCollection {
        let result = withLock {
            storage.videosCalls.append(
                VideosCall(
                    episodeNumber: episodeNumber,
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID,
                    filter: filter
                )
            )
            return storage.videosResult
        }

        return try result.get()
    }

    // MARK: - accountStates

    ///
    /// The arguments of a single call to
    /// ``accountStates(forEpisode:inSeason:inTVSeries:session:)``.
    ///
    public struct AccountStatesCall: Sendable {
        ///
        /// The `episodeNumber` argument the method was called with.
        ///
        public let episodeNumber: Int
        ///
        /// The `seasonNumber` argument the method was called with.
        ///
        public let seasonNumber: Int
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``accountStates(forEpisode:inSeason:inTVSeries:session:)``, in the
    /// order they were made.
    ///
    public var accountStatesCalls: [AccountStatesCall] {
        withLock { storage.accountStatesCalls }
    }

    ///
    /// The stubbed result returned by
    /// ``accountStates(forEpisode:inSeason:inTVSeries:session:)``.
    ///
    public var accountStatesResult: Result<AccountStates, TMDbError> {
        get { withLock { storage.accountStatesResult } }
        set { withLock { storage.accountStatesResult = newValue } }
    }

    ///
    /// Records the call and returns ``accountStatesResult``.
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number.
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed account states.
    ///
    public func accountStates(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) -> AccountStates {
        let result = withLock {
            storage.accountStatesCalls.append(
                AccountStatesCall(
                    episodeNumber: episodeNumber,
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID,
                    session: session
                )
            )
            return storage.accountStatesResult
        }

        return try result.get()
    }

    // MARK: - addRating

    ///
    /// The arguments of a single call to
    /// ``addRating(_:toEpisode:inSeason:inTVSeries:session:)``.
    ///
    public struct AddRatingCall: Sendable {
        ///
        /// The `rating` argument the method was called with.
        ///
        public let rating: Double
        ///
        /// The `episodeNumber` argument the method was called with.
        ///
        public let episodeNumber: Int
        ///
        /// The `seasonNumber` argument the method was called with.
        ///
        public let seasonNumber: Int
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``addRating(_:toEpisode:inSeason:inTVSeries:session:)``, in the order
    /// they were made.
    ///
    public var addRatingCalls: [AddRatingCall] {
        withLock { storage.addRatingCalls }
    }

    ///
    /// The stubbed result returned by ``addRating(_:toEpisode:inSeason:inTVSeries:session:)``.
    ///
    public var addRatingResult: Result<Void, TMDbError> {
        get { withLock { storage.addRatingResult } }
        set { withLock { storage.addRatingResult = newValue } }
    }

    ///
    /// Records the call and returns ``addRatingResult``.
    ///
    /// - Parameters:
    ///   - rating: The rating to add.
    ///   - episodeNumber: The episode number.
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func addRating(
        _ rating: Double,
        toEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.addRatingCalls.append(
                AddRatingCall(
                    rating: rating,
                    episodeNumber: episodeNumber,
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID,
                    session: session
                )
            )
            return storage.addRatingResult
        }

        return try result.get()
    }

    // MARK: - deleteRating

    ///
    /// The arguments of a single call to
    /// ``deleteRating(forEpisode:inSeason:inTVSeries:session:)``.
    ///
    public struct DeleteRatingCall: Sendable {
        ///
        /// The `episodeNumber` argument the method was called with.
        ///
        public let episodeNumber: Int
        ///
        /// The `seasonNumber` argument the method was called with.
        ///
        public let seasonNumber: Int
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``deleteRating(forEpisode:inSeason:inTVSeries:session:)``, in the
    /// order they were made.
    ///
    public var deleteRatingCalls: [DeleteRatingCall] {
        withLock { storage.deleteRatingCalls }
    }

    ///
    /// The stubbed result returned by ``deleteRating(forEpisode:inSeason:inTVSeries:session:)``.
    ///
    public var deleteRatingResult: Result<Void, TMDbError> {
        get { withLock { storage.deleteRatingResult } }
        set { withLock { storage.deleteRatingResult = newValue } }
    }

    ///
    /// Records the call and returns ``deleteRatingResult``.
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number.
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func deleteRating(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.deleteRatingCalls.append(
                DeleteRatingCall(
                    episodeNumber: episodeNumber,
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID,
                    session: session
                )
            )
            return storage.deleteRatingResult
        }

        return try result.get()
    }

    // MARK: - externalLinks

    ///
    /// The arguments of a single call to
    /// ``externalLinks(forEpisode:inSeason:inTVSeries:)``.
    ///
    public struct ExternalLinksCall: Sendable {
        ///
        /// The `episodeNumber` argument the method was called with.
        ///
        public let episodeNumber: Int
        ///
        /// The `seasonNumber` argument the method was called with.
        ///
        public let seasonNumber: Int
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
    }

    ///
    /// The recorded calls to ``externalLinks(forEpisode:inSeason:inTVSeries:)``, in the order they
    /// were made.
    ///
    public var externalLinksCalls: [ExternalLinksCall] {
        withLock { storage.externalLinksCalls }
    }

    ///
    /// The stubbed result returned by ``externalLinks(forEpisode:inSeason:inTVSeries:)``.
    ///
    public var externalLinksResult: Result<TVEpisodeExternalLinksCollection, TMDbError> {
        get { withLock { storage.externalLinksResult } }
        set { withLock { storage.externalLinksResult = newValue } }
    }

    ///
    /// Records the call and returns ``externalLinksResult``.
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number.
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed external links collection.
    ///
    public func externalLinks(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TVEpisodeExternalLinksCollection {
        let result = withLock {
            storage.externalLinksCalls.append(
                ExternalLinksCall(
                    episodeNumber: episodeNumber,
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID
                )
            )
            return storage.externalLinksResult
        }

        return try result.get()
    }

    // MARK: - translations

    ///
    /// The arguments of a single call to
    /// ``translations(forEpisode:inSeason:inTVSeries:)``.
    ///
    public struct TranslationsCall: Sendable {
        ///
        /// The `episodeNumber` argument the method was called with.
        ///
        public let episodeNumber: Int
        ///
        /// The `seasonNumber` argument the method was called with.
        ///
        public let seasonNumber: Int
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
    }

    ///
    /// The recorded calls to ``translations(forEpisode:inSeason:inTVSeries:)``, in the order they
    /// were made.
    ///
    public var translationsCalls: [TranslationsCall] {
        withLock { storage.translationsCalls }
    }

    ///
    /// The stubbed result returned by ``translations(forEpisode:inSeason:inTVSeries:)``.
    ///
    public var translationsResult: Result<
        TranslationCollection<TVEpisodeTranslationData>, TMDbError
    > {
        get { withLock { storage.translationsResult } }
        set { withLock { storage.translationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``translationsResult``.
    ///
    /// - Parameters:
    ///   - episodeNumber: The episode number.
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed translation collection.
    ///
    public func translations(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TranslationCollection<TVEpisodeTranslationData> {
        let result = withLock {
            storage.translationsCalls.append(
                TranslationsCall(
                    episodeNumber: episodeNumber,
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID
                )
            )
            return storage.translationsResult
        }

        return try result.get()
    }

    // MARK: - changes

    ///
    /// The arguments of a single call to ``changes(forEpisode:startDate:endDate:page:)``.
    ///
    public struct ChangesCall: Sendable {
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
    /// The recorded calls to ``changes(forEpisode:startDate:endDate:page:)``, in the order they
    /// were made.
    ///
    public var changesCalls: [ChangesCall] {
        withLock { storage.changesCalls }
    }

    ///
    /// The stubbed result returned by ``changes(forEpisode:startDate:endDate:page:)``.
    ///
    public var changesResult: Result<ChangeCollection, TMDbError> {
        get { withLock { storage.changesResult } }
        set { withLock { storage.changesResult = newValue } }
    }

    ///
    /// Records the call and returns ``changesResult``.
    ///
    /// - Parameters:
    ///   - episodeID: The identifier of the TV episode.
    ///   - startDate: The start date of the changes window.
    ///   - endDate: The end date of the changes window.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed change collection.
    ///
    public func changes(
        forEpisode episodeID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let result = withLock {
            storage.changesCalls.append(
                ChangesCall(
                    episodeID: episodeID,
                    startDate: startDate,
                    endDate: endDate,
                    page: page
                )
            )
            return storage.changesResult
        }

        return try result.get()
    }

}

// swiftlint:enable type_body_length
