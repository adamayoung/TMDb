//
//  MockTVSeasonService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length type_body_length
import Foundation
import TMDb

///
/// A mock `TVSeasonService` for use in tests.
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
public final class MockTVSeasonService: TVSeasonService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<TVSeason, TMDbError> = .success(.sample)
        var detailsAppendingCalls: [DetailsAppendingCall] = []
        var detailsAppendingResult: Result<TVSeasonDetailsResponse, TMDbError> = .success(.sample)
        var aggregateCreditsCalls: [AggregateCreditsCall] = []
        var aggregateCreditsResult: Result<TVSeasonAggregateCredits, TMDbError> = .success(.sample)
        var creditsCalls: [CreditsCall] = []
        var creditsResult: Result<ShowCredits, TMDbError> = .success(.sample)
        var imagesCalls: [ImagesCall] = []
        var imagesResult: Result<TVSeasonImageCollection, TMDbError> = .success(.sample)
        var videosCalls: [VideosCall] = []
        var videosResult: Result<VideoCollection, TMDbError> = .success(.sample)
        var accountStatesCalls: [AccountStatesCall] = []
        var accountStatesResult: Result<AccountStates, TMDbError> = .success(.sample)
        var externalLinksCalls: [ExternalLinksCall] = []
        var externalLinksResult: Result<TVSeasonExternalLinksCollection, TMDbError> =
            .success(.sample)
        var translationsCalls: [TranslationsCall] = []
        var translationsResult: Result<TranslationCollection<TVSeasonTranslationData>, TMDbError> =
            .success(.sample)
        var watchProvidersCalls: [WatchProvidersCall] = []
        var watchProvidersResult: Result<[ShowWatchProvidersByCountry], TMDbError> =
            .success(.samples)
        var changesCalls: [ChangesCall] = []
        var changesResult: Result<ChangeCollection, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock TV season service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forSeason:inTVSeries:language:)``.
    ///
    public struct DetailsCall: Sendable {
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
    /// The recorded calls to ``details(forSeason:inTVSeries:language:)``, in the order they
    /// were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forSeason:inTVSeries:language:)``.
    ///
    public var detailsResult: Result<TVSeason, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed TV season.
    ///
    public func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> TVSeason {
        let result = withLock {
            storage.detailsCalls.append(
                DetailsCall(
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
    /// ``details(forSeason:inTVSeries:appending:language:)``.
    ///
    public struct DetailsAppendingCall: Sendable {
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
        public let appending: TVSeasonAppendOption
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``details(forSeason:inTVSeries:appending:language:)``, in the
    /// order they were made.
    ///
    public var detailsAppendingCalls: [DetailsAppendingCall] {
        withLock { storage.detailsAppendingCalls }
    }

    ///
    /// The stubbed result returned by
    /// ``details(forSeason:inTVSeries:appending:language:)``.
    ///
    public var detailsAppendingResult: Result<TVSeasonDetailsResponse, TMDbError> {
        get { withLock { storage.detailsAppendingResult } }
        set { withLock { storage.detailsAppendingResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsAppendingResult``.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - appending: The additional data to append to the response.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed TV season details response.
    ///
    public func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        appending: TVSeasonAppendOption,
        language: String?
    ) async throws(TMDbError) -> TVSeasonDetailsResponse {
        let result = withLock {
            storage.detailsAppendingCalls.append(
                DetailsAppendingCall(
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

    // MARK: - aggregateCredits

    ///
    /// The arguments of a single call to
    /// ``aggregateCredits(forSeason:inTVSeries:language:)``.
    ///
    public struct AggregateCreditsCall: Sendable {
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
    /// The recorded calls to ``aggregateCredits(forSeason:inTVSeries:language:)``, in the
    /// order they were made.
    ///
    public var aggregateCreditsCalls: [AggregateCreditsCall] {
        withLock { storage.aggregateCreditsCalls }
    }

    ///
    /// The stubbed result returned by ``aggregateCredits(forSeason:inTVSeries:language:)``.
    ///
    public var aggregateCreditsResult: Result<TVSeasonAggregateCredits, TMDbError> {
        get { withLock { storage.aggregateCreditsResult } }
        set { withLock { storage.aggregateCreditsResult = newValue } }
    }

    ///
    /// Records the call and returns ``aggregateCreditsResult``.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed aggregate credits.
    ///
    public func aggregateCredits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> TVSeasonAggregateCredits {
        let result = withLock {
            storage.aggregateCreditsCalls.append(
                AggregateCreditsCall(
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID,
                    language: language
                )
            )
            return storage.aggregateCreditsResult
        }

        return try result.get()
    }

    // MARK: - credits

    ///
    /// The arguments of a single call to ``credits(forSeason:inTVSeries:language:)``.
    ///
    public struct CreditsCall: Sendable {
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
    /// The recorded calls to ``credits(forSeason:inTVSeries:language:)``, in the order they
    /// were made.
    ///
    public var creditsCalls: [CreditsCall] {
        withLock { storage.creditsCalls }
    }

    ///
    /// The stubbed result returned by ``credits(forSeason:inTVSeries:language:)``.
    ///
    public var creditsResult: Result<ShowCredits, TMDbError> {
        get { withLock { storage.creditsResult } }
        set { withLock { storage.creditsResult = newValue } }
    }

    ///
    /// Records the call and returns ``creditsResult``.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed credits.
    ///
    public func credits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> ShowCredits {
        let result = withLock {
            storage.creditsCalls.append(
                CreditsCall(
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
    /// The arguments of a single call to ``images(forSeason:inTVSeries:filter:)``.
    ///
    public struct ImagesCall: Sendable {
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
        public let filter: TVSeasonImageFilter?
    }

    ///
    /// The recorded calls to ``images(forSeason:inTVSeries:filter:)``, in the order they
    /// were made.
    ///
    public var imagesCalls: [ImagesCall] {
        withLock { storage.imagesCalls }
    }

    ///
    /// The stubbed result returned by ``images(forSeason:inTVSeries:filter:)``.
    ///
    public var imagesResult: Result<TVSeasonImageCollection, TMDbError> {
        get { withLock { storage.imagesResult } }
        set { withLock { storage.imagesResult = newValue } }
    }

    ///
    /// Records the call and returns ``imagesResult``.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - filter: An optional filter to apply to the images.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of images.
    ///
    public func images(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonImageFilter?
    ) async throws(TMDbError) -> TVSeasonImageCollection {
        let result = withLock {
            storage.imagesCalls.append(
                ImagesCall(
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
    /// The arguments of a single call to ``videos(forSeason:inTVSeries:filter:)``.
    ///
    public struct VideosCall: Sendable {
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
        public let filter: TVSeasonVideoFilter?
    }

    ///
    /// The recorded calls to ``videos(forSeason:inTVSeries:filter:)``, in the order they
    /// were made.
    ///
    public var videosCalls: [VideosCall] {
        withLock { storage.videosCalls }
    }

    ///
    /// The stubbed result returned by ``videos(forSeason:inTVSeries:filter:)``.
    ///
    public var videosResult: Result<VideoCollection, TMDbError> {
        get { withLock { storage.videosResult } }
        set { withLock { storage.videosResult = newValue } }
    }

    ///
    /// Records the call and returns ``videosResult``.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - filter: An optional filter to apply to the videos.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of videos.
    ///
    public func videos(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonVideoFilter?
    ) async throws(TMDbError) -> VideoCollection {
        let result = withLock {
            storage.videosCalls.append(
                VideosCall(
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
    /// The arguments of a single call to ``accountStates(forSeason:inTVSeries:session:)``.
    ///
    public struct AccountStatesCall: Sendable {
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
    /// The recorded calls to ``accountStates(forSeason:inTVSeries:session:)``, in the order
    /// they were made.
    ///
    public var accountStatesCalls: [AccountStatesCall] {
        withLock { storage.accountStatesCalls }
    }

    ///
    /// The stubbed result returned by ``accountStates(forSeason:inTVSeries:session:)``.
    ///
    public var accountStatesResult: Result<AccountStates, TMDbError> {
        get { withLock { storage.accountStatesResult } }
        set { withLock { storage.accountStatesResult = newValue } }
    }

    ///
    /// Records the call and returns ``accountStatesResult``.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed account states.
    ///
    public func accountStates(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) -> AccountStates {
        let result = withLock {
            storage.accountStatesCalls.append(
                AccountStatesCall(
                    seasonNumber: seasonNumber,
                    tvSeriesID: tvSeriesID,
                    session: session
                )
            )
            return storage.accountStatesResult
        }

        return try result.get()
    }

    // MARK: - externalLinks

    ///
    /// The arguments of a single call to ``externalLinks(forSeason:inTVSeries:)``.
    ///
    public struct ExternalLinksCall: Sendable {
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
    /// The recorded calls to ``externalLinks(forSeason:inTVSeries:)``, in the order they
    /// were made.
    ///
    public var externalLinksCalls: [ExternalLinksCall] {
        withLock { storage.externalLinksCalls }
    }

    ///
    /// The stubbed result returned by ``externalLinks(forSeason:inTVSeries:)``.
    ///
    public var externalLinksResult: Result<TVSeasonExternalLinksCollection, TMDbError> {
        get { withLock { storage.externalLinksResult } }
        set { withLock { storage.externalLinksResult = newValue } }
    }

    ///
    /// Records the call and returns ``externalLinksResult``.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of external links.
    ///
    public func externalLinks(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TVSeasonExternalLinksCollection {
        let result = withLock {
            storage.externalLinksCalls.append(
                ExternalLinksCall(seasonNumber: seasonNumber, tvSeriesID: tvSeriesID)
            )
            return storage.externalLinksResult
        }

        return try result.get()
    }

    // MARK: - translations

    ///
    /// The arguments of a single call to ``translations(forSeason:inTVSeries:)``.
    ///
    public struct TranslationsCall: Sendable {
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
    /// The recorded calls to ``translations(forSeason:inTVSeries:)``, in the order they
    /// were made.
    ///
    public var translationsCalls: [TranslationsCall] {
        withLock { storage.translationsCalls }
    }

    ///
    /// The stubbed result returned by ``translations(forSeason:inTVSeries:)``.
    ///
    public var translationsResult: Result<TranslationCollection<TVSeasonTranslationData>, TMDbError> {
        get { withLock { storage.translationsResult } }
        set { withLock { storage.translationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``translationsResult``.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of translations.
    ///
    public func translations(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TranslationCollection<TVSeasonTranslationData> {
        let result = withLock {
            storage.translationsCalls.append(
                TranslationsCall(seasonNumber: seasonNumber, tvSeriesID: tvSeriesID)
            )
            return storage.translationsResult
        }

        return try result.get()
    }

    // MARK: - watchProviders

    ///
    /// The arguments of a single call to ``watchProviders(forSeason:inTVSeries:)``.
    ///
    public struct WatchProvidersCall: Sendable {
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
    /// The recorded calls to ``watchProviders(forSeason:inTVSeries:)``, in the order they
    /// were made.
    ///
    public var watchProvidersCalls: [WatchProvidersCall] {
        withLock { storage.watchProvidersCalls }
    }

    ///
    /// The stubbed result returned by ``watchProviders(forSeason:inTVSeries:)``.
    ///
    public var watchProvidersResult: Result<[ShowWatchProvidersByCountry], TMDbError> {
        get { withLock { storage.watchProvidersResult } }
        set { withLock { storage.watchProvidersResult = newValue } }
    }

    ///
    /// Records the call and returns ``watchProvidersResult``.
    ///
    /// - Parameters:
    ///   - seasonNumber: The season number.
    ///   - tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed watch providers by country.
    ///
    public func watchProviders(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> [ShowWatchProvidersByCountry] {
        let result = withLock {
            storage.watchProvidersCalls.append(
                WatchProvidersCall(seasonNumber: seasonNumber, tvSeriesID: tvSeriesID)
            )
            return storage.watchProvidersResult
        }

        return try result.get()
    }

    // MARK: - changes

    ///
    /// The arguments of a single call to ``changes(forSeason:startDate:endDate:page:)``.
    ///
    public struct ChangesCall: Sendable {
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
    /// The recorded calls to ``changes(forSeason:startDate:endDate:page:)``, in the order
    /// they were made.
    ///
    public var changesCalls: [ChangesCall] {
        withLock { storage.changesCalls }
    }

    ///
    /// The stubbed result returned by ``changes(forSeason:startDate:endDate:page:)``.
    ///
    public var changesResult: Result<ChangeCollection, TMDbError> {
        get { withLock { storage.changesResult } }
        set { withLock { storage.changesResult = newValue } }
    }

    ///
    /// Records the call and returns ``changesResult``.
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
    public func changes(
        forSeason seasonID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let result = withLock {
            storage.changesCalls.append(
                ChangesCall(
                    seasonID: seasonID,
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
