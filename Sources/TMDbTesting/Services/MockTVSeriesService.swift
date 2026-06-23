//
//  MockTVSeriesService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length type_body_length
import Foundation
import TMDb

///
/// A mock `TVSeriesService` for use in tests.
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
public final class MockTVSeriesService: TVSeriesService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<TVSeries, TMDbError> = .success(.sample)
        var detailsAppendingCalls: [DetailsAppendingCall] = []
        var detailsAppendingResult: Result<TVSeriesDetailsResponse, TMDbError> = .success(.sample)
        var creditsCalls: [CreditsCall] = []
        var creditsResult: Result<ShowCredits, TMDbError> = .success(.sample)
        var aggregateCreditsCalls: [AggregateCreditsCall] = []
        var aggregateCreditsResult: Result<TVSeriesAggregateCredits, TMDbError> = .success(.sample)
        var reviewsCalls: [ReviewsCall] = []
        var reviewsResult: Result<ReviewPageableList, TMDbError> = .success(.sample)
        var imagesCalls: [ImagesCall] = []
        var imagesResult: Result<ImageCollection, TMDbError> = .success(.sample)
        var videosCalls: [VideosCall] = []
        var videosResult: Result<VideoCollection, TMDbError> = .success(.sample)
        var recommendationsCalls: [RecommendationsCall] = []
        var recommendationsResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var similarCalls: [SimilarCall] = []
        var similarResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var popularCalls: [PopularCall] = []
        var popularResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var airingTodayCalls: [AiringTodayCall] = []
        var airingTodayResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var onTheAirCalls: [OnTheAirCall] = []
        var onTheAirResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var topRatedCalls: [TopRatedCall] = []
        var topRatedResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var watchProvidersCalls: [WatchProvidersCall] = []
        var watchProvidersResult: Result<[ShowWatchProvidersByCountry], TMDbError> =
            .success(.samples)
        var externalLinksCalls: [ExternalLinksCall] = []
        var externalLinksResult: Result<TVSeriesExternalLinksCollection, TMDbError> =
            .success(.sample)
        var contentRatingsCalls: [ContentRatingsCall] = []
        var contentRatingsResult: Result<[ContentRating], TMDbError> = .success(.samples)
        var accountStatesCalls: [AccountStatesCall] = []
        var accountStatesResult: Result<AccountStates, TMDbError> = .success(.sample)
        var addRatingCalls: [AddRatingCall] = []
        var addRatingResult: Result<Void, TMDbError> = .success(())
        var deleteRatingCalls: [DeleteRatingCall] = []
        var deleteRatingResult: Result<Void, TMDbError> = .success(())
        var keywordsCalls: [KeywordsCall] = []
        var keywordsResult: Result<KeywordCollection, TMDbError> = .success(.sample)
        var alternativeTitlesCalls: [AlternativeTitlesCall] = []
        var alternativeTitlesResult: Result<AlternativeTitleCollection, TMDbError> =
            .success(.sample)
        var translationsCalls: [TranslationsCall] = []
        var translationsResult: Result<TranslationCollection<TVSeriesTranslationData>, TMDbError> =
            .success(.sample)
        var listsCalls: [ListsCall] = []
        var listsResult: Result<MediaListSummaryPageableList, TMDbError> = .success(.sample)
        var changesForTVSeriesCalls: [ChangesForTVSeriesCall] = []
        var changesForTVSeriesResult: Result<ChangeCollection, TMDbError> = .success(.sample)
        var latestCalls: [LatestCall] = []
        var latestResult: Result<TVSeries, TMDbError> = .success(.sample)
        var changesCalls: [ChangesCall] = []
        var changesResult: Result<ChangedIDCollection, TMDbError> = .success(.sample)
        var screenedTheatricallyCalls: [ScreenedTheatricallyCall] = []
        var screenedTheatricallyResult: Result<ScreenedTheatricallyCollection, TMDbError> =
            .success(.sample)
        var episodeGroupsCalls: [EpisodeGroupsCall] = []
        var episodeGroupsResult: Result<TVEpisodeGroupCollection, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock TV series service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forTVSeries:language:)``.
    ///
    public struct DetailsCall: Sendable {
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
    /// The recorded calls to ``details(forTVSeries:language:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forTVSeries:language:)``.
    ///
    public var detailsResult: Result<TVSeries, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func details(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> TVSeries {
        let result = withLock {
            storage.detailsCalls.append(
                DetailsCall(
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
    /// The arguments of a single call to ``details(forTVSeries:appending:language:)``.
    ///
    public struct DetailsAppendingCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `appending` argument the method was called with.
        ///
        public let appending: TVSeriesAppendOption
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``details(forTVSeries:appending:language:)``, in the order they
    /// were made.
    ///
    public var detailsAppendingCalls: [DetailsAppendingCall] {
        withLock { storage.detailsAppendingCalls }
    }

    ///
    /// The stubbed result returned by ``details(forTVSeries:appending:language:)``.
    ///
    public var detailsAppendingResult: Result<TVSeriesDetailsResponse, TMDbError> {
        get { withLock { storage.detailsAppendingResult } }
        set { withLock { storage.detailsAppendingResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsAppendingResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func details(
        forTVSeries tvSeriesID: TVSeries.ID,
        appending: TVSeriesAppendOption,
        language: String?
    ) async throws(TMDbError) -> TVSeriesDetailsResponse {
        let result = withLock {
            storage.detailsAppendingCalls.append(
                DetailsAppendingCall(
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
    /// The arguments of a single call to ``credits(forTVSeries:language:)``.
    ///
    public struct CreditsCall: Sendable {
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
    /// The recorded calls to ``credits(forTVSeries:language:)``, in the order they were made.
    ///
    public var creditsCalls: [CreditsCall] {
        withLock { storage.creditsCalls }
    }

    ///
    /// The stubbed result returned by ``credits(forTVSeries:language:)``.
    ///
    public var creditsResult: Result<ShowCredits, TMDbError> {
        get { withLock { storage.creditsResult } }
        set { withLock { storage.creditsResult = newValue } }
    }

    ///
    /// Records the call and returns ``creditsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func credits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> ShowCredits {
        let result = withLock {
            storage.creditsCalls.append(
                CreditsCall(
                    tvSeriesID: tvSeriesID,
                    language: language
                )
            )
            return storage.creditsResult
        }

        return try result.get()
    }

    // MARK: - aggregateCredits

    ///
    /// The arguments of a single call to ``aggregateCredits(forTVSeries:language:)``.
    ///
    public struct AggregateCreditsCall: Sendable {
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
    /// The recorded calls to ``aggregateCredits(forTVSeries:language:)``, in the order they
    /// were made.
    ///
    public var aggregateCreditsCalls: [AggregateCreditsCall] {
        withLock { storage.aggregateCreditsCalls }
    }

    ///
    /// The stubbed result returned by ``aggregateCredits(forTVSeries:language:)``.
    ///
    public var aggregateCreditsResult: Result<TVSeriesAggregateCredits, TMDbError> {
        get { withLock { storage.aggregateCreditsResult } }
        set { withLock { storage.aggregateCreditsResult = newValue } }
    }

    ///
    /// Records the call and returns ``aggregateCreditsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> TVSeriesAggregateCredits {
        let result = withLock {
            storage.aggregateCreditsCalls.append(
                AggregateCreditsCall(
                    tvSeriesID: tvSeriesID,
                    language: language
                )
            )
            return storage.aggregateCreditsResult
        }

        return try result.get()
    }

    // MARK: - reviews

    ///
    /// The arguments of a single call to ``reviews(forTVSeries:page:language:)``.
    ///
    public struct ReviewsCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
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
    /// The recorded calls to ``reviews(forTVSeries:page:language:)``, in the order they were made.
    ///
    public var reviewsCalls: [ReviewsCall] {
        withLock { storage.reviewsCalls }
    }

    ///
    /// The stubbed result returned by ``reviews(forTVSeries:page:language:)``.
    ///
    public var reviewsResult: Result<ReviewPageableList, TMDbError> {
        get { withLock { storage.reviewsResult } }
        set { withLock { storage.reviewsResult = newValue } }
    }

    ///
    /// Records the call and returns ``reviewsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> ReviewPageableList {
        let result = withLock {
            storage.reviewsCalls.append(
                ReviewsCall(
                    tvSeriesID: tvSeriesID,
                    page: page,
                    language: language
                )
            )
            return storage.reviewsResult
        }

        return try result.get()
    }

    // MARK: - images

    ///
    /// The arguments of a single call to ``images(forTVSeries:filter:)``.
    ///
    public struct ImagesCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: TVSeriesImageFilter?
    }

    ///
    /// The recorded calls to ``images(forTVSeries:filter:)``, in the order they were made.
    ///
    public var imagesCalls: [ImagesCall] {
        withLock { storage.imagesCalls }
    }

    ///
    /// The stubbed result returned by ``images(forTVSeries:filter:)``.
    ///
    public var imagesResult: Result<ImageCollection, TMDbError> {
        get { withLock { storage.imagesResult } }
        set { withLock { storage.imagesResult = newValue } }
    }

    ///
    /// Records the call and returns ``imagesResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func images(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesImageFilter?
    ) async throws(TMDbError) -> ImageCollection {
        let result = withLock {
            storage.imagesCalls.append(
                ImagesCall(
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
    /// The arguments of a single call to ``videos(forTVSeries:filter:)``.
    ///
    public struct VideosCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: TVSeriesVideoFilter?
    }

    ///
    /// The recorded calls to ``videos(forTVSeries:filter:)``, in the order they were made.
    ///
    public var videosCalls: [VideosCall] {
        withLock { storage.videosCalls }
    }

    ///
    /// The stubbed result returned by ``videos(forTVSeries:filter:)``.
    ///
    public var videosResult: Result<VideoCollection, TMDbError> {
        get { withLock { storage.videosResult } }
        set { withLock { storage.videosResult = newValue } }
    }

    ///
    /// Records the call and returns ``videosResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func videos(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesVideoFilter?
    ) async throws(TMDbError) -> VideoCollection {
        let result = withLock {
            storage.videosCalls.append(
                VideosCall(
                    tvSeriesID: tvSeriesID,
                    filter: filter
                )
            )
            return storage.videosResult
        }

        return try result.get()
    }

    // MARK: - recommendations

    ///
    /// The arguments of a single call to ``recommendations(forTVSeries:page:language:)``.
    ///
    public struct RecommendationsCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
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
    /// The recorded calls to ``recommendations(forTVSeries:page:language:)``, in the order they
    /// were made.
    ///
    public var recommendationsCalls: [RecommendationsCall] {
        withLock { storage.recommendationsCalls }
    }

    ///
    /// The stubbed result returned by ``recommendations(forTVSeries:page:language:)``.
    ///
    public var recommendationsResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.recommendationsResult } }
        set { withLock { storage.recommendationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``recommendationsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.recommendationsCalls.append(
                RecommendationsCall(
                    tvSeriesID: tvSeriesID,
                    page: page,
                    language: language
                )
            )
            return storage.recommendationsResult
        }

        return try result.get()
    }

    // MARK: - similar

    ///
    /// The arguments of a single call to ``similar(toTVSeries:page:language:)``.
    ///
    public struct SimilarCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
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
    /// The recorded calls to ``similar(toTVSeries:page:language:)``, in the order they were made.
    ///
    public var similarCalls: [SimilarCall] {
        withLock { storage.similarCalls }
    }

    ///
    /// The stubbed result returned by ``similar(toTVSeries:page:language:)``.
    ///
    public var similarResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.similarResult } }
        set { withLock { storage.similarResult = newValue } }
    }

    ///
    /// Records the call and returns ``similarResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.similarCalls.append(
                SimilarCall(
                    tvSeriesID: tvSeriesID,
                    page: page,
                    language: language
                )
            )
            return storage.similarResult
        }

        return try result.get()
    }

    // MARK: - popular

    ///
    /// The arguments of a single call to ``popular(page:language:)``.
    ///
    public struct PopularCall: Sendable {
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
    /// The recorded calls to ``popular(page:language:)``, in the order they were made.
    ///
    public var popularCalls: [PopularCall] {
        withLock { storage.popularCalls }
    }

    ///
    /// The stubbed result returned by ``popular(page:language:)``.
    ///
    public var popularResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.popularResult } }
        set { withLock { storage.popularResult = newValue } }
    }

    ///
    /// Records the call and returns ``popularResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func popular(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.popularCalls.append(
                PopularCall(
                    page: page,
                    language: language
                )
            )
            return storage.popularResult
        }

        return try result.get()
    }

    // MARK: - airingToday

    ///
    /// The arguments of a single call to ``airingToday(page:timezone:language:)``.
    ///
    public struct AiringTodayCall: Sendable {
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `timezone` argument the method was called with.
        ///
        public let timezone: String?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``airingToday(page:timezone:language:)``, in the order they were made.
    ///
    public var airingTodayCalls: [AiringTodayCall] {
        withLock { storage.airingTodayCalls }
    }

    ///
    /// The stubbed result returned by ``airingToday(page:timezone:language:)``.
    ///
    public var airingTodayResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.airingTodayResult } }
        set { withLock { storage.airingTodayResult = newValue } }
    }

    ///
    /// Records the call and returns ``airingTodayResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func airingToday(
        page: Int?,
        timezone: String?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.airingTodayCalls.append(
                AiringTodayCall(
                    page: page,
                    timezone: timezone,
                    language: language
                )
            )
            return storage.airingTodayResult
        }

        return try result.get()
    }

    // MARK: - onTheAir

    ///
    /// The arguments of a single call to ``onTheAir(page:timezone:language:)``.
    ///
    public struct OnTheAirCall: Sendable {
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `timezone` argument the method was called with.
        ///
        public let timezone: String?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``onTheAir(page:timezone:language:)``, in the order they were made.
    ///
    public var onTheAirCalls: [OnTheAirCall] {
        withLock { storage.onTheAirCalls }
    }

    ///
    /// The stubbed result returned by ``onTheAir(page:timezone:language:)``.
    ///
    public var onTheAirResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.onTheAirResult } }
        set { withLock { storage.onTheAirResult = newValue } }
    }

    ///
    /// Records the call and returns ``onTheAirResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func onTheAir(
        page: Int?,
        timezone: String?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.onTheAirCalls.append(
                OnTheAirCall(
                    page: page,
                    timezone: timezone,
                    language: language
                )
            )
            return storage.onTheAirResult
        }

        return try result.get()
    }

    // MARK: - topRated

    ///
    /// The arguments of a single call to ``topRated(page:language:)``.
    ///
    public struct TopRatedCall: Sendable {
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
    /// The recorded calls to ``topRated(page:language:)``, in the order they were made.
    ///
    public var topRatedCalls: [TopRatedCall] {
        withLock { storage.topRatedCalls }
    }

    ///
    /// The stubbed result returned by ``topRated(page:language:)``.
    ///
    public var topRatedResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.topRatedResult } }
        set { withLock { storage.topRatedResult = newValue } }
    }

    ///
    /// Records the call and returns ``topRatedResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func topRated(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.topRatedCalls.append(
                TopRatedCall(
                    page: page,
                    language: language
                )
            )
            return storage.topRatedResult
        }

        return try result.get()
    }

    // MARK: - watchProviders

    ///
    /// The arguments of a single call to ``watchProviders(forTVSeries:)``.
    ///
    public struct WatchProvidersCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
    }

    ///
    /// The recorded calls to ``watchProviders(forTVSeries:)``, in the order they were made.
    ///
    public var watchProvidersCalls: [WatchProvidersCall] {
        withLock { storage.watchProvidersCalls }
    }

    ///
    /// The stubbed result returned by ``watchProviders(forTVSeries:)``.
    ///
    public var watchProvidersResult: Result<[ShowWatchProvidersByCountry], TMDbError> {
        get { withLock { storage.watchProvidersResult } }
        set { withLock { storage.watchProvidersResult = newValue } }
    }

    ///
    /// Records the call and returns ``watchProvidersResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func watchProviders(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> [ShowWatchProvidersByCountry] {
        let result = withLock {
            storage.watchProvidersCalls.append(
                WatchProvidersCall(
                    tvSeriesID: tvSeriesID
                )
            )
            return storage.watchProvidersResult
        }

        return try result.get()
    }

    // MARK: - externalLinks

    ///
    /// The arguments of a single call to ``externalLinks(forTVSeries:)``.
    ///
    public struct ExternalLinksCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
    }

    ///
    /// The recorded calls to ``externalLinks(forTVSeries:)``, in the order they were made.
    ///
    public var externalLinksCalls: [ExternalLinksCall] {
        withLock { storage.externalLinksCalls }
    }

    ///
    /// The stubbed result returned by ``externalLinks(forTVSeries:)``.
    ///
    public var externalLinksResult: Result<TVSeriesExternalLinksCollection, TMDbError> {
        get { withLock { storage.externalLinksResult } }
        set { withLock { storage.externalLinksResult = newValue } }
    }

    ///
    /// Records the call and returns ``externalLinksResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func externalLinks(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TVSeriesExternalLinksCollection {
        let result = withLock {
            storage.externalLinksCalls.append(
                ExternalLinksCall(
                    tvSeriesID: tvSeriesID
                )
            )
            return storage.externalLinksResult
        }

        return try result.get()
    }

    // MARK: - contentRatings

    ///
    /// The arguments of a single call to ``contentRatings(forTVSeries:)``.
    ///
    public struct ContentRatingsCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
    }

    ///
    /// The recorded calls to ``contentRatings(forTVSeries:)``, in the order they were made.
    ///
    public var contentRatingsCalls: [ContentRatingsCall] {
        withLock { storage.contentRatingsCalls }
    }

    ///
    /// The stubbed result returned by ``contentRatings(forTVSeries:)``.
    ///
    public var contentRatingsResult: Result<[ContentRating], TMDbError> {
        get { withLock { storage.contentRatingsResult } }
        set { withLock { storage.contentRatingsResult = newValue } }
    }

    ///
    /// Records the call and returns ``contentRatingsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func contentRatings(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> [ContentRating] {
        let result = withLock {
            storage.contentRatingsCalls.append(
                ContentRatingsCall(
                    tvSeriesID: tvSeriesID
                )
            )
            return storage.contentRatingsResult
        }

        return try result.get()
    }

    // MARK: - accountStates

    ///
    /// The arguments of a single call to ``accountStates(forTVSeries:session:)``.
    ///
    public struct AccountStatesCall: Sendable {
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
    /// The recorded calls to ``accountStates(forTVSeries:session:)``, in the order they were made.
    ///
    public var accountStatesCalls: [AccountStatesCall] {
        withLock { storage.accountStatesCalls }
    }

    ///
    /// The stubbed result returned by ``accountStates(forTVSeries:session:)``.
    ///
    public var accountStatesResult: Result<AccountStates, TMDbError> {
        get { withLock { storage.accountStatesResult } }
        set { withLock { storage.accountStatesResult = newValue } }
    }

    ///
    /// Records the call and returns ``accountStatesResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func accountStates(
        forTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) -> AccountStates {
        let result = withLock {
            storage.accountStatesCalls.append(
                AccountStatesCall(
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
    /// The arguments of a single call to ``addRating(_:toTVSeries:session:)``.
    ///
    public struct AddRatingCall: Sendable {
        ///
        /// The `rating` argument the method was called with.
        ///
        public let rating: Double
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
    /// The recorded calls to ``addRating(_:toTVSeries:session:)``, in the order they were made.
    ///
    public var addRatingCalls: [AddRatingCall] {
        withLock { storage.addRatingCalls }
    }

    ///
    /// The stubbed result returned by ``addRating(_:toTVSeries:session:)``.
    ///
    public var addRatingResult: Result<Void, TMDbError> {
        get { withLock { storage.addRatingResult } }
        set { withLock { storage.addRatingResult = newValue } }
    }

    ///
    /// Records the call and returns ``addRatingResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func addRating(
        _ rating: Double,
        toTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.addRatingCalls.append(
                AddRatingCall(
                    rating: rating,
                    tvSeriesID: tvSeriesID,
                    session: session
                )
            )
            return storage.addRatingResult
        }

        try result.get()
    }

    // MARK: - deleteRating

    ///
    /// The arguments of a single call to ``deleteRating(forTVSeries:session:)``.
    ///
    public struct DeleteRatingCall: Sendable {
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
    /// The recorded calls to ``deleteRating(forTVSeries:session:)``, in the order they were made.
    ///
    public var deleteRatingCalls: [DeleteRatingCall] {
        withLock { storage.deleteRatingCalls }
    }

    ///
    /// The stubbed result returned by ``deleteRating(forTVSeries:session:)``.
    ///
    public var deleteRatingResult: Result<Void, TMDbError> {
        get { withLock { storage.deleteRatingResult } }
        set { withLock { storage.deleteRatingResult = newValue } }
    }

    ///
    /// Records the call and returns ``deleteRatingResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func deleteRating(
        forTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.deleteRatingCalls.append(
                DeleteRatingCall(
                    tvSeriesID: tvSeriesID,
                    session: session
                )
            )
            return storage.deleteRatingResult
        }

        try result.get()
    }

    // MARK: - keywords

    ///
    /// The arguments of a single call to ``keywords(forTVSeries:)``.
    ///
    public struct KeywordsCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
    }

    ///
    /// The recorded calls to ``keywords(forTVSeries:)``, in the order they were made.
    ///
    public var keywordsCalls: [KeywordsCall] {
        withLock { storage.keywordsCalls }
    }

    ///
    /// The stubbed result returned by ``keywords(forTVSeries:)``.
    ///
    public var keywordsResult: Result<KeywordCollection, TMDbError> {
        get { withLock { storage.keywordsResult } }
        set { withLock { storage.keywordsResult = newValue } }
    }

    ///
    /// Records the call and returns ``keywordsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func keywords(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> KeywordCollection {
        let result = withLock {
            storage.keywordsCalls.append(
                KeywordsCall(
                    tvSeriesID: tvSeriesID
                )
            )
            return storage.keywordsResult
        }

        return try result.get()
    }

    // MARK: - alternativeTitles

    ///
    /// The arguments of a single call to ``alternativeTitles(forTVSeries:)``.
    ///
    public struct AlternativeTitlesCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
    }

    ///
    /// The recorded calls to ``alternativeTitles(forTVSeries:)``, in the order they were made.
    ///
    public var alternativeTitlesCalls: [AlternativeTitlesCall] {
        withLock { storage.alternativeTitlesCalls }
    }

    ///
    /// The stubbed result returned by ``alternativeTitles(forTVSeries:)``.
    ///
    public var alternativeTitlesResult: Result<AlternativeTitleCollection, TMDbError> {
        get { withLock { storage.alternativeTitlesResult } }
        set { withLock { storage.alternativeTitlesResult = newValue } }
    }

    ///
    /// Records the call and returns ``alternativeTitlesResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func alternativeTitles(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> AlternativeTitleCollection {
        let result = withLock {
            storage.alternativeTitlesCalls.append(
                AlternativeTitlesCall(
                    tvSeriesID: tvSeriesID
                )
            )
            return storage.alternativeTitlesResult
        }

        return try result.get()
    }

    // MARK: - translations

    ///
    /// The arguments of a single call to ``translations(forTVSeries:)``.
    ///
    public struct TranslationsCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
    }

    ///
    /// The recorded calls to ``translations(forTVSeries:)``, in the order they were made.
    ///
    public var translationsCalls: [TranslationsCall] {
        withLock { storage.translationsCalls }
    }

    ///
    /// The stubbed result returned by ``translations(forTVSeries:)``.
    ///
    public var translationsResult: Result<TranslationCollection<TVSeriesTranslationData>, TMDbError> {
        get { withLock { storage.translationsResult } }
        set { withLock { storage.translationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``translationsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func translations(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TranslationCollection<TVSeriesTranslationData> {
        let result = withLock {
            storage.translationsCalls.append(
                TranslationsCall(
                    tvSeriesID: tvSeriesID
                )
            )
            return storage.translationsResult
        }

        return try result.get()
    }

    // MARK: - lists

    ///
    /// The arguments of a single call to ``lists(forTVSeries:page:language:)``.
    ///
    public struct ListsCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
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
    /// The recorded calls to ``lists(forTVSeries:page:language:)``, in the order they were made.
    ///
    public var listsCalls: [ListsCall] {
        withLock { storage.listsCalls }
    }

    ///
    /// The stubbed result returned by ``lists(forTVSeries:page:language:)``.
    ///
    public var listsResult: Result<MediaListSummaryPageableList, TMDbError> {
        get { withLock { storage.listsResult } }
        set { withLock { storage.listsResult = newValue } }
    }

    ///
    /// Records the call and returns ``listsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func lists(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        let result = withLock {
            storage.listsCalls.append(
                ListsCall(
                    tvSeriesID: tvSeriesID,
                    page: page,
                    language: language
                )
            )
            return storage.listsResult
        }

        return try result.get()
    }

    // MARK: - changesForTVSeries

    ///
    /// The arguments of a single call to ``changes(forTVSeries:startDate:endDate:page:)``.
    ///
    public struct ChangesForTVSeriesCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
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
    /// The recorded calls to ``changes(forTVSeries:startDate:endDate:page:)``, in the order they
    /// were made.
    ///
    public var changesForTVSeriesCalls: [ChangesForTVSeriesCall] {
        withLock { storage.changesForTVSeriesCalls }
    }

    ///
    /// The stubbed result returned by ``changes(forTVSeries:startDate:endDate:page:)``.
    ///
    public var changesForTVSeriesResult: Result<ChangeCollection, TMDbError> {
        get { withLock { storage.changesForTVSeriesResult } }
        set { withLock { storage.changesForTVSeriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``changesForTVSeriesResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let result = withLock {
            storage.changesForTVSeriesCalls.append(
                ChangesForTVSeriesCall(
                    tvSeriesID: tvSeriesID,
                    startDate: startDate,
                    endDate: endDate,
                    page: page
                )
            )
            return storage.changesForTVSeriesResult
        }

        return try result.get()
    }

    // MARK: - latest

    ///
    /// The arguments of a single call to ``latest()``.
    ///
    public struct LatestCall: Sendable {}

    ///
    /// The recorded calls to ``latest()``, in the order they were made.
    ///
    public var latestCalls: [LatestCall] {
        withLock { storage.latestCalls }
    }

    ///
    /// The stubbed result returned by ``latest()``.
    ///
    public var latestResult: Result<TVSeries, TMDbError> {
        get { withLock { storage.latestResult } }
        set { withLock { storage.latestResult = newValue } }
    }

    ///
    /// Records the call and returns ``latestResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func latest() async throws(TMDbError) -> TVSeries {
        let result = withLock {
            storage.latestCalls.append(LatestCall())
            return storage.latestResult
        }

        return try result.get()
    }

    // MARK: - changes

    ///
    /// The arguments of a single call to ``changes(startDate:endDate:page:)``.
    ///
    public struct ChangesCall: Sendable {
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
    /// The recorded calls to ``changes(startDate:endDate:page:)``, in the order they were made.
    ///
    public var changesCalls: [ChangesCall] {
        withLock { storage.changesCalls }
    }

    ///
    /// The stubbed result returned by ``changes(startDate:endDate:page:)``.
    ///
    public var changesResult: Result<ChangedIDCollection, TMDbError> {
        get { withLock { storage.changesResult } }
        set { withLock { storage.changesResult = newValue } }
    }

    ///
    /// Records the call and returns ``changesResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func changes(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        let result = withLock {
            storage.changesCalls.append(
                ChangesCall(
                    startDate: startDate,
                    endDate: endDate,
                    page: page
                )
            )
            return storage.changesResult
        }

        return try result.get()
    }

    // MARK: - screenedTheatrically

    ///
    /// The arguments of a single call to ``screenedTheatrically(forTVSeries:)``.
    ///
    public struct ScreenedTheatricallyCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
    }

    ///
    /// The recorded calls to ``screenedTheatrically(forTVSeries:)``, in the order they were made.
    ///
    public var screenedTheatricallyCalls: [ScreenedTheatricallyCall] {
        withLock { storage.screenedTheatricallyCalls }
    }

    ///
    /// The stubbed result returned by ``screenedTheatrically(forTVSeries:)``.
    ///
    public var screenedTheatricallyResult: Result<ScreenedTheatricallyCollection, TMDbError> {
        get { withLock { storage.screenedTheatricallyResult } }
        set { withLock { storage.screenedTheatricallyResult = newValue } }
    }

    ///
    /// Records the call and returns ``screenedTheatricallyResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func screenedTheatrically(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> ScreenedTheatricallyCollection {
        let result = withLock {
            storage.screenedTheatricallyCalls.append(
                ScreenedTheatricallyCall(
                    tvSeriesID: tvSeriesID
                )
            )
            return storage.screenedTheatricallyResult
        }

        return try result.get()
    }

    // MARK: - episodeGroups

    ///
    /// The arguments of a single call to ``episodeGroups(forTVSeries:)``.
    ///
    public struct EpisodeGroupsCall: Sendable {
        ///
        /// The `tvSeriesID` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
    }

    ///
    /// The recorded calls to ``episodeGroups(forTVSeries:)``, in the order they were made.
    ///
    public var episodeGroupsCalls: [EpisodeGroupsCall] {
        withLock { storage.episodeGroupsCalls }
    }

    ///
    /// The stubbed result returned by ``episodeGroups(forTVSeries:)``.
    ///
    public var episodeGroupsResult: Result<TVEpisodeGroupCollection, TMDbError> {
        get { withLock { storage.episodeGroupsResult } }
        set { withLock { storage.episodeGroupsResult = newValue } }
    }

    ///
    /// Records the call and returns ``episodeGroupsResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed result.
    ///
    public func episodeGroups(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TVEpisodeGroupCollection {
        let result = withLock {
            storage.episodeGroupsCalls.append(
                EpisodeGroupsCall(
                    tvSeriesID: tvSeriesID
                )
            )
            return storage.episodeGroupsResult
        }

        return try result.get()
    }

}

// swiftlint:enable type_body_length
