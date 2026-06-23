//
//  MockCompanyService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `CompanyService` for use in tests.
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
public final class MockCompanyService: CompanyService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<Company, TMDbError> = .success(.sample)
        var alternativeNamesCalls: [AlternativeNamesCall] = []
        var alternativeNamesResult: Result<CompanyAlternativeNameCollection, TMDbError> =
            .success(.sample)
        var imagesCalls: [ImagesCall] = []
        var imagesResult: Result<CompanyImageCollection, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock company service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(forCompany:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: Company.ID
    }

    ///
    /// The recorded calls to ``details(forCompany:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(forCompany:)``.
    ///
    public var detailsResult: Result<Company, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameter id: The identifier of the company.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed company.
    ///
    public func details(forCompany id: Company.ID) async throws(TMDbError) -> Company {
        let result = withLock {
            storage.detailsCalls.append(DetailsCall(id: id))
            return storage.detailsResult
        }

        return try result.get()
    }

    // MARK: - alternativeNames

    ///
    /// The arguments of a single call to ``alternativeNames(forCompany:)``.
    ///
    public struct AlternativeNamesCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: Company.ID
    }

    ///
    /// The recorded calls to ``alternativeNames(forCompany:)``, in the order they were made.
    ///
    public var alternativeNamesCalls: [AlternativeNamesCall] {
        withLock { storage.alternativeNamesCalls }
    }

    ///
    /// The stubbed result returned by ``alternativeNames(forCompany:)``.
    ///
    public var alternativeNamesResult: Result<CompanyAlternativeNameCollection, TMDbError> {
        get { withLock { storage.alternativeNamesResult } }
        set { withLock { storage.alternativeNamesResult = newValue } }
    }

    ///
    /// Records the call and returns ``alternativeNamesResult``.
    ///
    /// - Parameter id: The identifier of the company.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of alternative names.
    ///
    public func alternativeNames(
        forCompany id: Company.ID
    ) async throws(TMDbError) -> CompanyAlternativeNameCollection {
        let result = withLock {
            storage.alternativeNamesCalls.append(AlternativeNamesCall(id: id))
            return storage.alternativeNamesResult
        }

        return try result.get()
    }

    // MARK: - images

    ///
    /// The arguments of a single call to ``images(forCompany:)``.
    ///
    public struct ImagesCall: Sendable {
        ///
        /// The `id` argument the method was called with.
        ///
        public let id: Company.ID
    }

    ///
    /// The recorded calls to ``images(forCompany:)``, in the order they were made.
    ///
    public var imagesCalls: [ImagesCall] {
        withLock { storage.imagesCalls }
    }

    ///
    /// The stubbed result returned by ``images(forCompany:)``.
    ///
    public var imagesResult: Result<CompanyImageCollection, TMDbError> {
        get { withLock { storage.imagesResult } }
        set { withLock { storage.imagesResult = newValue } }
    }

    ///
    /// Records the call and returns ``imagesResult``.
    ///
    /// - Parameter id: The identifier of the company.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed collection of images.
    ///
    public func images(
        forCompany id: Company.ID
    ) async throws(TMDbError) -> CompanyImageCollection {
        let result = withLock {
            storage.imagesCalls.append(ImagesCall(id: id))
            return storage.imagesResult
        }

        return try result.get()
    }

}
