//
//  MockPersonService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length type_body_length
import Foundation
import TMDb

///
/// A mock `PersonService` for use in tests.
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
public final class MockPersonService: PersonService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<Person, TMDbError> = .success(.sample)
        var detailsAppendingCalls: [DetailsAppendingCall] = []
        var detailsAppendingResult: Result<PersonDetailsResponse, TMDbError> = .success(.sample)
        var combinedCreditsCalls: [CombinedCreditsCall] = []
        var combinedCreditsResult: Result<PersonCombinedCredits, TMDbError> = .success(.sample)
        var movieCreditsCalls: [MovieCreditsCall] = []
        var movieCreditsResult: Result<PersonMovieCredits, TMDbError> = .success(.sample)
        var tvSeriesCreditsCalls: [TVSeriesCreditsCall] = []
        var tvSeriesCreditsResult: Result<PersonTVSeriesCredits, TMDbError> = .success(.sample)
        var imagesCalls: [ImagesCall] = []
        var imagesResult: Result<PersonImageCollection, TMDbError> = .success(.sample)
        var popularCalls: [PopularCall] = []
        var popularResult: Result<PersonPageableList, TMDbError> = .success(.sample)
        var externalLinksCalls: [ExternalLinksCall] = []
        var externalLinksResult: Result<PersonExternalLinksCollection, TMDbError> = .success(.sample)
        var taggedImagesCalls: [TaggedImagesCall] = []
        var taggedImagesResult: Result<TaggedImagePageableList, TMDbError> = .success(.sample)
        var translationsCalls: [TranslationsCall] = []
        var translationsResult: Result<TranslationCollection<PersonTranslationData>, TMDbError> =
            .success(.sample)
        var changesForPersonCalls: [ChangesForPersonCall] = []
        var changesForPersonResult: Result<ChangeCollection, TMDbError> = .success(.sample)
        var latestCalls: [LatestCall] = []
        var latestResult: Result<Person, TMDbError> = .success(.sample)
        var changesCalls: [ChangesCall] = []
        var changesResult: Result<ChangedIDCollection, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock person service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forPerson:language:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `personID` argument the method was called with.
        ///
        public let personID: Person.ID
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``details(forPerson:language:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forPerson:language:)``.
    ///
    public var detailsResult: Result<Person, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameters:
    ///   - personID: The identifier of the person.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed person.
    ///
    public func details(
        forPerson personID: Person.ID,
        language: String?
    ) async throws(TMDbError) -> Person {
        let result = withLock {
            storage.detailsCalls.append(DetailsCall(personID: personID, language: language))
            return storage.detailsResult
        }

        return try result.get()
    }

    // MARK: - detailsAppending

    ///
    /// The arguments of a single call to ``details(forPerson:appending:language:)``.
    ///
    public struct DetailsAppendingCall: Sendable {
        ///
        /// The `personID` argument the method was called with.
        ///
        public let personID: Person.ID
        ///
        /// The `appending` argument the method was called with.
        ///
        public let appending: PersonAppendOption
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``details(forPerson:appending:language:)``, in the order they were
    /// made.
    ///
    public var detailsAppendingCalls: [DetailsAppendingCall] {
        withLock { storage.detailsAppendingCalls }
    }

    ///
    /// The stubbed result returned by ``details(forPerson:appending:language:)``.
    ///
    public var detailsAppendingResult: Result<PersonDetailsResponse, TMDbError> {
        get { withLock { storage.detailsAppendingResult } }
        set { withLock { storage.detailsAppendingResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsAppendingResult``.
    ///
    /// - Parameters:
    ///   - personID: The identifier of the person.
    ///   - appending: The additional data to append to the response.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed person details response.
    ///
    public func details(
        forPerson personID: Person.ID,
        appending: PersonAppendOption,
        language: String?
    ) async throws(TMDbError) -> PersonDetailsResponse {
        let result = withLock {
            storage.detailsAppendingCalls.append(
                DetailsAppendingCall(
                    personID: personID,
                    appending: appending,
                    language: language
                )
            )
            return storage.detailsAppendingResult
        }

        return try result.get()
    }

    // MARK: - combinedCredits

    ///
    /// The arguments of a single call to ``combinedCredits(forPerson:language:)``.
    ///
    public struct CombinedCreditsCall: Sendable {
        ///
        /// The `personID` argument the method was called with.
        ///
        public let personID: Person.ID
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``combinedCredits(forPerson:language:)``, in the order they were
    /// made.
    ///
    public var combinedCreditsCalls: [CombinedCreditsCall] {
        withLock { storage.combinedCreditsCalls }
    }

    ///
    /// The stubbed result returned by ``combinedCredits(forPerson:language:)``.
    ///
    public var combinedCreditsResult: Result<PersonCombinedCredits, TMDbError> {
        get { withLock { storage.combinedCreditsResult } }
        set { withLock { storage.combinedCreditsResult = newValue } }
    }

    ///
    /// Records the call and returns ``combinedCreditsResult``.
    ///
    /// - Parameters:
    ///   - personID: The identifier of the person.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed combined credits.
    ///
    public func combinedCredits(
        forPerson personID: Person.ID,
        language: String?
    ) async throws(TMDbError) -> PersonCombinedCredits {
        let result = withLock {
            storage.combinedCreditsCalls.append(
                CombinedCreditsCall(personID: personID, language: language)
            )
            return storage.combinedCreditsResult
        }

        return try result.get()
    }

    // MARK: - movieCredits

    ///
    /// The arguments of a single call to ``movieCredits(forPerson:language:)``.
    ///
    public struct MovieCreditsCall: Sendable {
        ///
        /// The `personID` argument the method was called with.
        ///
        public let personID: Person.ID
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``movieCredits(forPerson:language:)``, in the order they were made.
    ///
    public var movieCreditsCalls: [MovieCreditsCall] {
        withLock { storage.movieCreditsCalls }
    }

    ///
    /// The stubbed result returned by ``movieCredits(forPerson:language:)``.
    ///
    public var movieCreditsResult: Result<PersonMovieCredits, TMDbError> {
        get { withLock { storage.movieCreditsResult } }
        set { withLock { storage.movieCreditsResult = newValue } }
    }

    ///
    /// Records the call and returns ``movieCreditsResult``.
    ///
    /// - Parameters:
    ///   - personID: The identifier of the person.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed movie credits.
    ///
    public func movieCredits(
        forPerson personID: Person.ID,
        language: String?
    ) async throws(TMDbError) -> PersonMovieCredits {
        let result = withLock {
            storage.movieCreditsCalls.append(
                MovieCreditsCall(personID: personID, language: language)
            )
            return storage.movieCreditsResult
        }

        return try result.get()
    }

    // MARK: - tvSeriesCredits

    ///
    /// The arguments of a single call to ``tvSeriesCredits(forPerson:language:)``.
    ///
    public struct TVSeriesCreditsCall: Sendable {
        ///
        /// The `personID` argument the method was called with.
        ///
        public let personID: Person.ID
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``tvSeriesCredits(forPerson:language:)``, in the order they were
    /// made.
    ///
    public var tvSeriesCreditsCalls: [TVSeriesCreditsCall] {
        withLock { storage.tvSeriesCreditsCalls }
    }

    ///
    /// The stubbed result returned by ``tvSeriesCredits(forPerson:language:)``.
    ///
    public var tvSeriesCreditsResult: Result<PersonTVSeriesCredits, TMDbError> {
        get { withLock { storage.tvSeriesCreditsResult } }
        set { withLock { storage.tvSeriesCreditsResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvSeriesCreditsResult``.
    ///
    /// - Parameters:
    ///   - personID: The identifier of the person.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed TV series credits.
    ///
    public func tvSeriesCredits(
        forPerson personID: Person.ID,
        language: String?
    ) async throws(TMDbError) -> PersonTVSeriesCredits {
        let result = withLock {
            storage.tvSeriesCreditsCalls.append(
                TVSeriesCreditsCall(personID: personID, language: language)
            )
            return storage.tvSeriesCreditsResult
        }

        return try result.get()
    }

    // MARK: - images

    ///
    /// The arguments of a single call to ``images(forPerson:)``.
    ///
    public struct ImagesCall: Sendable {
        ///
        /// The `personID` argument the method was called with.
        ///
        public let personID: Person.ID
    }

    ///
    /// The recorded calls to ``images(forPerson:)``, in the order they were made.
    ///
    public var imagesCalls: [ImagesCall] {
        withLock { storage.imagesCalls }
    }

    ///
    /// The stubbed result returned by ``images(forPerson:)``.
    ///
    public var imagesResult: Result<PersonImageCollection, TMDbError> {
        get { withLock { storage.imagesResult } }
        set { withLock { storage.imagesResult = newValue } }
    }

    ///
    /// Records the call and returns ``imagesResult``.
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed image collection.
    ///
    public func images(forPerson personID: Person.ID) async throws(TMDbError) -> PersonImageCollection {
        let result = withLock {
            storage.imagesCalls.append(ImagesCall(personID: personID))
            return storage.imagesResult
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
    public var popularResult: Result<PersonPageableList, TMDbError> {
        get { withLock { storage.popularResult } }
        set { withLock { storage.popularResult = newValue } }
    }

    ///
    /// Records the call and returns ``popularResult``.
    ///
    /// - Parameters:
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of people.
    ///
    public func popular(page: Int?, language: String?) async throws(TMDbError) -> PersonPageableList {
        let result = withLock {
            storage.popularCalls.append(PopularCall(page: page, language: language))
            return storage.popularResult
        }

        return try result.get()
    }

    // MARK: - externalLinks

    ///
    /// The arguments of a single call to ``externalLinks(forPerson:)``.
    ///
    public struct ExternalLinksCall: Sendable {
        ///
        /// The `personID` argument the method was called with.
        ///
        public let personID: Person.ID
    }

    ///
    /// The recorded calls to ``externalLinks(forPerson:)``, in the order they were made.
    ///
    public var externalLinksCalls: [ExternalLinksCall] {
        withLock { storage.externalLinksCalls }
    }

    ///
    /// The stubbed result returned by ``externalLinks(forPerson:)``.
    ///
    public var externalLinksResult: Result<PersonExternalLinksCollection, TMDbError> {
        get { withLock { storage.externalLinksResult } }
        set { withLock { storage.externalLinksResult = newValue } }
    }

    ///
    /// Records the call and returns ``externalLinksResult``.
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed external links collection.
    ///
    public func externalLinks(
        forPerson personID: Person.ID
    ) async throws(TMDbError) -> PersonExternalLinksCollection {
        let result = withLock {
            storage.externalLinksCalls.append(ExternalLinksCall(personID: personID))
            return storage.externalLinksResult
        }

        return try result.get()
    }

    // MARK: - taggedImages

    ///
    /// The arguments of a single call to ``taggedImages(forPerson:page:)``.
    ///
    public struct TaggedImagesCall: Sendable {
        ///
        /// The `personID` argument the method was called with.
        ///
        public let personID: Person.ID
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
    }

    ///
    /// The recorded calls to ``taggedImages(forPerson:page:)``, in the order they were made.
    ///
    public var taggedImagesCalls: [TaggedImagesCall] {
        withLock { storage.taggedImagesCalls }
    }

    ///
    /// The stubbed result returned by ``taggedImages(forPerson:page:)``.
    ///
    public var taggedImagesResult: Result<TaggedImagePageableList, TMDbError> {
        get { withLock { storage.taggedImagesResult } }
        set { withLock { storage.taggedImagesResult = newValue } }
    }

    ///
    /// Records the call and returns ``taggedImagesResult``.
    ///
    /// - Parameters:
    ///   - personID: The identifier of the person.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of tagged images.
    ///
    public func taggedImages(
        forPerson personID: Person.ID,
        page: Int?
    ) async throws(TMDbError) -> TaggedImagePageableList {
        let result = withLock {
            storage.taggedImagesCalls.append(TaggedImagesCall(personID: personID, page: page))
            return storage.taggedImagesResult
        }

        return try result.get()
    }

    // MARK: - translations

    ///
    /// The arguments of a single call to ``translations(forPerson:)``.
    ///
    public struct TranslationsCall: Sendable {
        ///
        /// The `personID` argument the method was called with.
        ///
        public let personID: Person.ID
    }

    ///
    /// The recorded calls to ``translations(forPerson:)``, in the order they were made.
    ///
    public var translationsCalls: [TranslationsCall] {
        withLock { storage.translationsCalls }
    }

    ///
    /// The stubbed result returned by ``translations(forPerson:)``.
    ///
    public var translationsResult: Result<TranslationCollection<PersonTranslationData>, TMDbError> {
        get { withLock { storage.translationsResult } }
        set { withLock { storage.translationsResult = newValue } }
    }

    ///
    /// Records the call and returns ``translationsResult``.
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed translation collection.
    ///
    public func translations(
        forPerson personID: Person.ID
    ) async throws(TMDbError) -> TranslationCollection<PersonTranslationData> {
        let result = withLock {
            storage.translationsCalls.append(TranslationsCall(personID: personID))
            return storage.translationsResult
        }

        return try result.get()
    }

    // MARK: - changesForPerson

    ///
    /// The arguments of a single call to ``changes(forPerson:startDate:endDate:page:)``.
    ///
    public struct ChangesForPersonCall: Sendable {
        ///
        /// The `personID` argument the method was called with.
        ///
        public let personID: Person.ID
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
    /// The recorded calls to ``changes(forPerson:startDate:endDate:page:)``, in the order they
    /// were made.
    ///
    public var changesForPersonCalls: [ChangesForPersonCall] {
        withLock { storage.changesForPersonCalls }
    }

    ///
    /// The stubbed result returned by ``changes(forPerson:startDate:endDate:page:)``.
    ///
    public var changesForPersonResult: Result<ChangeCollection, TMDbError> {
        get { withLock { storage.changesForPersonResult } }
        set { withLock { storage.changesForPersonResult = newValue } }
    }

    ///
    /// Records the call and returns ``changesForPersonResult``.
    ///
    /// - Parameters:
    ///   - personID: The identifier of the person.
    ///   - startDate: The start date of the changes.
    ///   - endDate: The end date of the changes.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed change collection.
    ///
    public func changes(
        forPerson personID: Person.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let result = withLock {
            storage.changesForPersonCalls.append(
                ChangesForPersonCall(
                    personID: personID,
                    startDate: startDate,
                    endDate: endDate,
                    page: page
                )
            )
            return storage.changesForPersonResult
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
    public var latestResult: Result<Person, TMDbError> {
        get { withLock { storage.latestResult } }
        set { withLock { storage.latestResult = newValue } }
    }

    ///
    /// Records the call and returns ``latestResult``.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed latest person.
    ///
    public func latest() async throws(TMDbError) -> Person {
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
    /// - Parameters:
    ///   - startDate: The start date of the changes.
    ///   - endDate: The end date of the changes.
    ///   - page: The page of results to return.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed changed ID collection.
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

}

// swiftlint:enable type_body_length
