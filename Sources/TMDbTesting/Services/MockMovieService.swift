//
//  MockMovieService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length type_body_length
import Foundation
import TMDb

///
/// A mock `MovieService` for use in tests.
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
public final class MockMovieService: MovieService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<Movie, TMDbError> = .success(.sample)
        var detailsAppendingCalls: [DetailsAppendingCall] = []
        var detailsAppendingResult: Result<MovieDetailsResponse, TMDbError> = .success(.sample)
        var creditsCalls: [CreditsCall] = []
        var creditsResult: Result<ShowCredits, TMDbError> = .success(.sample)
        var reviewsCalls: [ReviewsCall] = []
        var reviewsResult: Result<ReviewPageableList, TMDbError> = .success(.sample)
        var imagesCalls: [ImagesCall] = []
        var imagesResult: Result<ImageCollection, TMDbError> = .success(.sample)
        var videosCalls: [VideosCall] = []
        var videosResult: Result<VideoCollection, TMDbError> = .success(.sample)
        var recommendationsCalls: [RecommendationsCall] = []
        var recommendationsResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var similarCalls: [SimilarCall] = []
        var similarResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var nowPlayingCalls: [NowPlayingCall] = []
        var nowPlayingResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var popularCalls: [PopularCall] = []
        var popularResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var topRatedCalls: [TopRatedCall] = []
        var topRatedResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var upcomingCalls: [UpcomingCall] = []
        var upcomingResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var watchProvidersCalls: [WatchProvidersCall] = []
        var watchProvidersResult: Result<[ShowWatchProvidersByCountry], TMDbError> =
            .success(.samples)
        var externalLinksCalls: [ExternalLinksCall] = []
        var externalLinksResult: Result<MovieExternalLinksCollection, TMDbError> = .success(.sample)
        var releaseDatesCalls: [ReleaseDatesCall] = []
        var releaseDatesResult: Result<[MovieReleaseDatesByCountry], TMDbError> = .success(.samples)
        var accountStatesCalls: [AccountStatesCall] = []
        var accountStatesResult: Result<AccountStates, TMDbError> = .success(.sample)
        var addRatingCalls: [AddRatingCall] = []
        var addRatingResult: Result<Void, TMDbError> = .success(())
        var deleteRatingCalls: [DeleteRatingCall] = []
        var deleteRatingResult: Result<Void, TMDbError> = .success(())
        var alternativeTitlesCalls: [AlternativeTitlesCall] = []
        var alternativeTitlesResult: Result<AlternativeTitleCollection, TMDbError> =
            .success(.sample)
        var translationsCalls: [TranslationsCall] = []
        var translationsResult: Result<TranslationCollection<MovieTranslationData>, TMDbError> =
            .success(.sample)
        var listsCalls: [ListsCall] = []
        var listsResult: Result<MediaListSummaryPageableList, TMDbError> = .success(.sample)
        var changesForMovieCalls: [ChangesForMovieCall] = []
        var changesForMovieResult: Result<ChangeCollection, TMDbError> = .success(.sample)
        var changesCalls: [ChangesCall] = []
        var changesResult: Result<ChangedIDCollection, TMDbError> = .success(.sample)
        var keywordsCalls: [KeywordsCall] = []
        var keywordsResult: Result<KeywordCollection, TMDbError> = .success(.sample)
        var latestCalls: [LatestCall] = []
        var latestResult: Result<Movie, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock movie service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forMovie:language:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``details(forMovie:language:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forMovie:language:)``.
    ///
    public var detailsResult: Result<Movie, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed movie.
    ///
    public func details(forMovie movieID: Movie.ID, language: String?) async throws(TMDbError)
    -> Movie {
        let result = withLock {
            storage.detailsCalls.append(DetailsCall(movieID: movieID, language: language))
            return storage.detailsResult
        }

        return try result.get()
    }

    // MARK: - detailsAppending

    ///
    /// The arguments of a single call to ``details(forMovie:appending:language:)``.
    ///
    public struct DetailsAppendingCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `appending` argument the method was called with.
        ///
        public let appending: MovieAppendOption
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``details(forMovie:appending:language:)``, in the order they
    /// were made.
    ///
    public var detailsAppendingCalls: [DetailsAppendingCall] {
        withLock { storage.detailsAppendingCalls }
    }

    ///
    /// The stubbed result returned by ``details(forMovie:appending:language:)``.
    ///
    public var detailsAppendingResult: Result<MovieDetailsResponse, TMDbError> {
        get { withLock { storage.detailsAppendingResult } }
        set { withLock { storage.detailsAppendingResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsAppendingResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - appending: The additional data to append to the response.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed movie details response.
    ///
    public func details(
        forMovie movieID: Movie.ID,
        appending: MovieAppendOption,
        language: String?
    ) async throws(TMDbError) -> MovieDetailsResponse {
        let result = withLock {
            storage.detailsAppendingCalls.append(
                DetailsAppendingCall(movieID: movieID, appending: appending, language: language)
            )
            return storage.detailsAppendingResult
        }

        return try result.get()
    }

    // MARK: - credits

    ///
    /// The arguments of a single call to ``credits(forMovie:language:)``.
    ///
    public struct CreditsCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``credits(forMovie:language:)``, in the order they were made.
    ///
    public var creditsCalls: [CreditsCall] {
        withLock { storage.creditsCalls }
    }

    ///
    /// The stubbed result returned by ``credits(forMovie:language:)``.
    ///
    public var creditsResult: Result<ShowCredits, TMDbError> {
        get { withLock { storage.creditsResult } }
        set { withLock { storage.creditsResult = newValue } }
    }

    ///
    /// Records the call and returns ``creditsResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed credits.
    ///
    public func credits(
        forMovie movieID: Movie.ID,
        language: String?
    ) async throws(TMDbError) -> ShowCredits {
        let result = withLock {
            storage.creditsCalls.append(CreditsCall(movieID: movieID, language: language))
            return storage.creditsResult
        }

        return try result.get()
    }

    // MARK: - reviews

    ///
    /// The arguments of a single call to ``reviews(forMovie:page:language:)``.
    ///
    public struct ReviewsCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
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
    /// The recorded calls to ``reviews(forMovie:page:language:)``, in the order they were made.
    ///
    public var reviewsCalls: [ReviewsCall] {
        withLock { storage.reviewsCalls }
    }

    ///
    /// The stubbed result returned by ``reviews(forMovie:page:language:)``.
    ///
    public var reviewsResult: Result<ReviewPageableList, TMDbError> {
        get { withLock { storage.reviewsResult } }
        set { withLock { storage.reviewsResult = newValue } }
    }

    ///
    /// Records the call and returns ``reviewsResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of reviews.
    ///
    public func reviews(
        forMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> ReviewPageableList {
        let result = withLock {
            storage.reviewsCalls.append(
                ReviewsCall(movieID: movieID, page: page, language: language)
            )
            return storage.reviewsResult
        }

        return try result.get()
    }

    // MARK: - images

    ///
    /// The arguments of a single call to ``images(forMovie:filter:)``.
    ///
    public struct ImagesCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: MovieImageFilter?
    }

    ///
    /// The recorded calls to ``images(forMovie:filter:)``, in the order they were made.
    ///
    public var imagesCalls: [ImagesCall] {
        withLock { storage.imagesCalls }
    }

    ///
    /// The stubbed result returned by ``images(forMovie:filter:)``.
    ///
    public var imagesResult: Result<ImageCollection, TMDbError> {
        get { withLock { storage.imagesResult } }
        set { withLock { storage.imagesResult = newValue } }
    }

    ///
    /// Records the call and returns ``imagesResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - filter: Image filter to apply.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed image collection.
    ///
    public func images(
        forMovie movieID: Movie.ID,
        filter: MovieImageFilter?
    ) async throws(TMDbError) -> ImageCollection {
        let result = withLock {
            storage.imagesCalls.append(ImagesCall(movieID: movieID, filter: filter))
            return storage.imagesResult
        }

        return try result.get()
    }

    // MARK: - videos

    ///
    /// The arguments of a single call to ``videos(forMovie:filter:)``.
    ///
    public struct VideosCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: MovieVideoFilter?
    }

    ///
    /// The recorded calls to ``videos(forMovie:filter:)``, in the order they were made.
    ///
    public var videosCalls: [VideosCall] {
        withLock { storage.videosCalls }
    }

    ///
    /// The stubbed result returned by ``videos(forMovie:filter:)``.
    ///
    public var videosResult: Result<VideoCollection, TMDbError> {
        get { withLock { storage.videosResult } }
        set { withLock { storage.videosResult = newValue } }
    }

    ///
    /// Records the call and returns ``videosResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - filter: Video filter to apply.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed video collection.
    ///
    public func videos(
        forMovie movieID: Movie.ID,
        filter: MovieVideoFilter?
    ) async throws(TMDbError) -> VideoCollection {
        let result = withLock {
            storage.videosCalls.append(VideosCall(movieID: movieID, filter: filter))
            return storage.videosResult
        }

        return try result.get()
    }

    // MARK: - recommendations

    ///
    /// The arguments of a single call to ``recommendations(forMovie:page:language:)``.
    ///
    public struct RecommendationsCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
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
    /// The recorded calls to ``recommendations(forMovie:page:language:)``, in the order they
    /// were made.
    ///
    public var recommendationsCalls: [RecommendationsCall] {
        withLock { storage.recommendationsCalls }
    }

    ///
    /// The stubbed result returned by ``recommendations(forMovie:page:language:)``.
    ///
    public var recommendationsResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.recommendationsResult } }
        set { withLock { storage.recommendationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``recommendationsResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of recommended movies.
    ///
    public func recommendations(
        forMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.recommendationsCalls.append(
                RecommendationsCall(movieID: movieID, page: page, language: language)
            )
            return storage.recommendationsResult
        }

        return try result.get()
    }

    // MARK: - similar

    ///
    /// The arguments of a single call to ``similar(toMovie:page:language:)``.
    ///
    public struct SimilarCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
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
    /// The recorded calls to ``similar(toMovie:page:language:)``, in the order they were made.
    ///
    public var similarCalls: [SimilarCall] {
        withLock { storage.similarCalls }
    }

    ///
    /// The stubbed result returned by ``similar(toMovie:page:language:)``.
    ///
    public var similarResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.similarResult } }
        set { withLock { storage.similarResult = newValue } }
    }

    ///
    /// Records the call and returns ``similarResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of similar movies.
    ///
    public func similar(
        toMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.similarCalls.append(
                SimilarCall(movieID: movieID, page: page, language: language)
            )
            return storage.similarResult
        }

        return try result.get()
    }

    // MARK: - nowPlaying

    ///
    /// The arguments of a single call to ``nowPlaying(page:country:language:)``.
    ///
    public struct NowPlayingCall: Sendable {
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `country` argument the method was called with.
        ///
        public let country: String?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``nowPlaying(page:country:language:)``, in the order they were made.
    ///
    public var nowPlayingCalls: [NowPlayingCall] {
        withLock { storage.nowPlayingCalls }
    }

    ///
    /// The stubbed result returned by ``nowPlaying(page:country:language:)``.
    ///
    public var nowPlayingResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.nowPlayingResult } }
        set { withLock { storage.nowPlayingResult = newValue } }
    }

    ///
    /// Records the call and returns ``nowPlayingResult``.
    ///
    /// - Parameters:
    ///   - page: The page of results to return.
    ///   - country: ISO 3166-1 country code.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of now playing movies.
    ///
    public func nowPlaying(
        page: Int?,
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.nowPlayingCalls.append(
                NowPlayingCall(page: page, country: country, language: language)
            )
            return storage.nowPlayingResult
        }

        return try result.get()
    }

    // MARK: - popular

    ///
    /// The arguments of a single call to ``popular(page:country:language:)``.
    ///
    public struct PopularCall: Sendable {
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `country` argument the method was called with.
        ///
        public let country: String?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``popular(page:country:language:)``, in the order they were made.
    ///
    public var popularCalls: [PopularCall] {
        withLock { storage.popularCalls }
    }

    ///
    /// The stubbed result returned by ``popular(page:country:language:)``.
    ///
    public var popularResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.popularResult } }
        set { withLock { storage.popularResult = newValue } }
    }

    ///
    /// Records the call and returns ``popularResult``.
    ///
    /// - Parameters:
    ///   - page: The page of results to return.
    ///   - country: ISO 3166-1 country code.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of popular movies.
    ///
    public func popular(
        page: Int?,
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.popularCalls.append(
                PopularCall(page: page, country: country, language: language)
            )
            return storage.popularResult
        }

        return try result.get()
    }

    // MARK: - topRated

    ///
    /// The arguments of a single call to ``topRated(page:country:language:)``.
    ///
    public struct TopRatedCall: Sendable {
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `country` argument the method was called with.
        ///
        public let country: String?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``topRated(page:country:language:)``, in the order they were made.
    ///
    public var topRatedCalls: [TopRatedCall] {
        withLock { storage.topRatedCalls }
    }

    ///
    /// The stubbed result returned by ``topRated(page:country:language:)``.
    ///
    public var topRatedResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.topRatedResult } }
        set { withLock { storage.topRatedResult = newValue } }
    }

    ///
    /// Records the call and returns ``topRatedResult``.
    ///
    /// - Parameters:
    ///   - page: The page of results to return.
    ///   - country: ISO 3166-1 country code.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of top rated movies.
    ///
    public func topRated(
        page: Int?,
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.topRatedCalls.append(
                TopRatedCall(page: page, country: country, language: language)
            )
            return storage.topRatedResult
        }

        return try result.get()
    }

    // MARK: - upcoming

    ///
    /// The arguments of a single call to ``upcoming(page:country:language:)``.
    ///
    public struct UpcomingCall: Sendable {
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `country` argument the method was called with.
        ///
        public let country: String?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``upcoming(page:country:language:)``, in the order they were made.
    ///
    public var upcomingCalls: [UpcomingCall] {
        withLock { storage.upcomingCalls }
    }

    ///
    /// The stubbed result returned by ``upcoming(page:country:language:)``.
    ///
    public var upcomingResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.upcomingResult } }
        set { withLock { storage.upcomingResult = newValue } }
    }

    ///
    /// Records the call and returns ``upcomingResult``.
    ///
    /// - Parameters:
    ///   - page: The page of results to return.
    ///   - country: ISO 3166-1 country code.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of upcoming movies.
    ///
    public func upcoming(
        page: Int?,
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.upcomingCalls.append(
                UpcomingCall(page: page, country: country, language: language)
            )
            return storage.upcomingResult
        }

        return try result.get()
    }

    // MARK: - watchProviders

    ///
    /// The arguments of a single call to ``watchProviders(forMovie:)``.
    ///
    public struct WatchProvidersCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
    }

    ///
    /// The recorded calls to ``watchProviders(forMovie:)``, in the order they were made.
    ///
    public var watchProvidersCalls: [WatchProvidersCall] {
        withLock { storage.watchProvidersCalls }
    }

    ///
    /// The stubbed result returned by ``watchProviders(forMovie:)``.
    ///
    public var watchProvidersResult: Result<[ShowWatchProvidersByCountry], TMDbError> {
        get { withLock { storage.watchProvidersResult } }
        set { withLock { storage.watchProvidersResult = newValue } }
    }

    ///
    /// Records the call and returns ``watchProvidersResult``.
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed watch providers grouped by country.
    ///
    public func watchProviders(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> [ShowWatchProvidersByCountry] {
        let result = withLock {
            storage.watchProvidersCalls.append(WatchProvidersCall(movieID: movieID))
            return storage.watchProvidersResult
        }

        return try result.get()
    }

    // MARK: - externalLinks

    ///
    /// The arguments of a single call to ``externalLinks(forMovie:)``.
    ///
    public struct ExternalLinksCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
    }

    ///
    /// The recorded calls to ``externalLinks(forMovie:)``, in the order they were made.
    ///
    public var externalLinksCalls: [ExternalLinksCall] {
        withLock { storage.externalLinksCalls }
    }

    ///
    /// The stubbed result returned by ``externalLinks(forMovie:)``.
    ///
    public var externalLinksResult: Result<MovieExternalLinksCollection, TMDbError> {
        get { withLock { storage.externalLinksResult } }
        set { withLock { storage.externalLinksResult = newValue } }
    }

    ///
    /// Records the call and returns ``externalLinksResult``.
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed external links collection.
    ///
    public func externalLinks(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> MovieExternalLinksCollection {
        let result = withLock {
            storage.externalLinksCalls.append(ExternalLinksCall(movieID: movieID))
            return storage.externalLinksResult
        }

        return try result.get()
    }

    // MARK: - releaseDates

    ///
    /// The arguments of a single call to ``releaseDates(forMovie:)``.
    ///
    public struct ReleaseDatesCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
    }

    ///
    /// The recorded calls to ``releaseDates(forMovie:)``, in the order they were made.
    ///
    public var releaseDatesCalls: [ReleaseDatesCall] {
        withLock { storage.releaseDatesCalls }
    }

    ///
    /// The stubbed result returned by ``releaseDates(forMovie:)``.
    ///
    public var releaseDatesResult: Result<[MovieReleaseDatesByCountry], TMDbError> {
        get { withLock { storage.releaseDatesResult } }
        set { withLock { storage.releaseDatesResult = newValue } }
    }

    ///
    /// Records the call and returns ``releaseDatesResult``.
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed release dates grouped by country.
    ///
    public func releaseDates(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> [MovieReleaseDatesByCountry] {
        let result = withLock {
            storage.releaseDatesCalls.append(ReleaseDatesCall(movieID: movieID))
            return storage.releaseDatesResult
        }

        return try result.get()
    }

    // MARK: - accountStates

    ///
    /// The arguments of a single call to ``accountStates(forMovie:session:)``.
    ///
    public struct AccountStatesCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``accountStates(forMovie:session:)``, in the order they were made.
    ///
    public var accountStatesCalls: [AccountStatesCall] {
        withLock { storage.accountStatesCalls }
    }

    ///
    /// The stubbed result returned by ``accountStates(forMovie:session:)``.
    ///
    public var accountStatesResult: Result<AccountStates, TMDbError> {
        get { withLock { storage.accountStatesResult } }
        set { withLock { storage.accountStatesResult = newValue } }
    }

    ///
    /// Records the call and returns ``accountStatesResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed account states.
    ///
    public func accountStates(
        forMovie movieID: Movie.ID,
        session: Session
    ) async throws(TMDbError) -> AccountStates {
        let result = withLock {
            storage.accountStatesCalls.append(
                AccountStatesCall(movieID: movieID, session: session)
            )
            return storage.accountStatesResult
        }

        return try result.get()
    }

    // MARK: - addRating

    ///
    /// The arguments of a single call to ``addRating(_:toMovie:session:)``.
    ///
    public struct AddRatingCall: Sendable {
        ///
        /// The `rating` argument the method was called with.
        ///
        public let rating: Double
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``addRating(_:toMovie:session:)``, in the order they were made.
    ///
    public var addRatingCalls: [AddRatingCall] {
        withLock { storage.addRatingCalls }
    }

    ///
    /// The stubbed result returned by ``addRating(_:toMovie:session:)``.
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
    ///   - movieID: The identifier of the movie.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func addRating(
        _ rating: Double,
        toMovie movieID: Movie.ID,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.addRatingCalls.append(
                AddRatingCall(rating: rating, movieID: movieID, session: session)
            )
            return storage.addRatingResult
        }

        return try result.get()
    }

    // MARK: - deleteRating

    ///
    /// The arguments of a single call to ``deleteRating(forMovie:session:)``.
    ///
    public struct DeleteRatingCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``deleteRating(forMovie:session:)``, in the order they were made.
    ///
    public var deleteRatingCalls: [DeleteRatingCall] {
        withLock { storage.deleteRatingCalls }
    }

    ///
    /// The stubbed result returned by ``deleteRating(forMovie:session:)``.
    ///
    public var deleteRatingResult: Result<Void, TMDbError> {
        get { withLock { storage.deleteRatingResult } }
        set { withLock { storage.deleteRatingResult = newValue } }
    }

    ///
    /// Records the call and returns ``deleteRatingResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func deleteRating(
        forMovie movieID: Movie.ID,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.deleteRatingCalls.append(
                DeleteRatingCall(movieID: movieID, session: session)
            )
            return storage.deleteRatingResult
        }

        return try result.get()
    }

    // MARK: - alternativeTitles

    ///
    /// The arguments of a single call to ``alternativeTitles(forMovie:country:language:)``.
    ///
    public struct AlternativeTitlesCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `country` argument the method was called with.
        ///
        public let country: String?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``alternativeTitles(forMovie:country:language:)``, in the order
    /// they were made.
    ///
    public var alternativeTitlesCalls: [AlternativeTitlesCall] {
        withLock { storage.alternativeTitlesCalls }
    }

    ///
    /// The stubbed result returned by ``alternativeTitles(forMovie:country:language:)``.
    ///
    public var alternativeTitlesResult: Result<AlternativeTitleCollection, TMDbError> {
        get { withLock { storage.alternativeTitlesResult } }
        set { withLock { storage.alternativeTitlesResult = newValue } }
    }

    ///
    /// Records the call and returns ``alternativeTitlesResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - country: ISO 3166-1 country code.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed alternative title collection.
    ///
    public func alternativeTitles(
        forMovie movieID: Movie.ID,
        country: String?,
        language: String?
    ) async throws(TMDbError) -> AlternativeTitleCollection {
        let result = withLock {
            storage.alternativeTitlesCalls.append(
                AlternativeTitlesCall(movieID: movieID, country: country, language: language)
            )
            return storage.alternativeTitlesResult
        }

        return try result.get()
    }

    // MARK: - translations

    ///
    /// The arguments of a single call to ``translations(forMovie:)``.
    ///
    public struct TranslationsCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
    }

    ///
    /// The recorded calls to ``translations(forMovie:)``, in the order they were made.
    ///
    public var translationsCalls: [TranslationsCall] {
        withLock { storage.translationsCalls }
    }

    ///
    /// The stubbed result returned by ``translations(forMovie:)``.
    ///
    public var translationsResult: Result<TranslationCollection<MovieTranslationData>, TMDbError> {
        get { withLock { storage.translationsResult } }
        set { withLock { storage.translationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``translationsResult``.
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed translation collection.
    ///
    public func translations(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> TranslationCollection<MovieTranslationData> {
        let result = withLock {
            storage.translationsCalls.append(TranslationsCall(movieID: movieID))
            return storage.translationsResult
        }

        return try result.get()
    }

    // MARK: - lists

    ///
    /// The arguments of a single call to ``lists(forMovie:page:language:)``.
    ///
    public struct ListsCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
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
    /// The recorded calls to ``lists(forMovie:page:language:)``, in the order they were made.
    ///
    public var listsCalls: [ListsCall] {
        withLock { storage.listsCalls }
    }

    ///
    /// The stubbed result returned by ``lists(forMovie:page:language:)``.
    ///
    public var listsResult: Result<MediaListSummaryPageableList, TMDbError> {
        get { withLock { storage.listsResult } }
        set { withLock { storage.listsResult = newValue } }
    }

    ///
    /// Records the call and returns ``listsResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of media list summaries.
    ///
    public func lists(
        forMovie movieID: Movie.ID,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        let result = withLock {
            storage.listsCalls.append(
                ListsCall(movieID: movieID, page: page, language: language)
            )
            return storage.listsResult
        }

        return try result.get()
    }

    // MARK: - changesForMovie

    ///
    /// The arguments of a single call to ``changes(forMovie:startDate:endDate:page:)``.
    ///
    public struct ChangesForMovieCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
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
    /// The recorded calls to ``changes(forMovie:startDate:endDate:page:)``, in the order they
    /// were made.
    ///
    public var changesForMovieCalls: [ChangesForMovieCall] {
        withLock { storage.changesForMovieCalls }
    }

    ///
    /// The stubbed result returned by ``changes(forMovie:startDate:endDate:page:)``.
    ///
    public var changesForMovieResult: Result<ChangeCollection, TMDbError> {
        get { withLock { storage.changesForMovieResult } }
        set { withLock { storage.changesForMovieResult = newValue } }
    }

    ///
    /// Records the call and returns ``changesForMovieResult``.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - startDate: The start date of the change window.
    ///   - endDate: The end date of the change window.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed change collection.
    ///
    public func changes(
        forMovie movieID: Movie.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let result = withLock {
            storage.changesForMovieCalls.append(
                ChangesForMovieCall(
                    movieID: movieID,
                    startDate: startDate,
                    endDate: endDate,
                    page: page
                )
            )
            return storage.changesForMovieResult
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
    /// - Parameters:
    ///   - startDate: The start date of the change window.
    ///   - endDate: The end date of the change window.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of changed identifiers.
    ///
    public func changes(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        let result = withLock {
            storage.changesCalls.append(
                ChangesCall(startDate: startDate, endDate: endDate, page: page)
            )
            return storage.changesResult
        }

        return try result.get()
    }

    // MARK: - keywords

    ///
    /// The arguments of a single call to ``keywords(forMovie:)``.
    ///
    public struct KeywordsCall: Sendable {
        ///
        /// The `movieID` argument the method was called with.
        ///
        public let movieID: Movie.ID
    }

    ///
    /// The recorded calls to ``keywords(forMovie:)``, in the order they were made.
    ///
    public var keywordsCalls: [KeywordsCall] {
        withLock { storage.keywordsCalls }
    }

    ///
    /// The stubbed result returned by ``keywords(forMovie:)``.
    ///
    public var keywordsResult: Result<KeywordCollection, TMDbError> {
        get { withLock { storage.keywordsResult } }
        set { withLock { storage.keywordsResult = newValue } }
    }

    ///
    /// Records the call and returns ``keywordsResult``.
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed keyword collection.
    ///
    public func keywords(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> KeywordCollection {
        let result = withLock {
            storage.keywordsCalls.append(KeywordsCall(movieID: movieID))
            return storage.keywordsResult
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
    public var latestResult: Result<Movie, TMDbError> {
        get { withLock { storage.latestResult } }
        set { withLock { storage.latestResult = newValue } }
    }

    ///
    /// Records the call and returns ``latestResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed latest movie.
    ///
    public func latest() async throws(TMDbError) -> Movie {
        let result = withLock {
            storage.latestCalls.append(LatestCall())
            return storage.latestResult
        }

        return try result.get()
    }

}

// swiftlint:enable type_body_length
