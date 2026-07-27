//
//  ImageService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for generating fully qualified image URLs from the image
/// paths returned by TMDb.
///
/// Models such as ``Movie``, ``TVSeries`` and ``Person`` carry image *paths*, not
/// URLs. Building a URL from a path needs TMDb's images configuration, which this
/// service fetches on first use and caches for the lifetime of the client — so
/// resolving an image URL is a single call:
///
/// ```swift
/// let url = try await client.images.posterURL(for: movie.posterPath, size: .width(500))
/// ```
///
/// The configuration is fetched **at most once**, no matter how many callers ask
/// concurrently. Call ``preload()`` at launch to pay that cost up front rather
/// than on the first image.
///
/// - Note: For resolving many URLs at once, prefer fetching
///   ``imagesConfiguration()`` once and calling the synchronous helpers on
///   ``ImagesConfiguration`` directly — that avoids an `await` per image.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol ImageService: Sendable {

    ///
    /// Returns TMDb's images configuration, fetching it on first use and caching
    /// it for the lifetime of the client.
    ///
    /// Concurrent callers share a single fetch. A failed fetch is not cached, so a
    /// later call retries.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The images configuration.
    ///
    func imagesConfiguration() async throws(TMDbError) -> ImagesConfiguration

    ///
    /// Discards the cached images configuration and fetches it again.
    ///
    /// TMDb's images configuration changes rarely, so this is seldom needed — it
    /// exists for long-lived processes that would otherwise hold one value
    /// indefinitely.
    ///
    /// A fetch already in progress when this is called is left to run: callers
    /// that asked before the refresh receive that earlier value, and callers
    /// arriving afterwards join the new fetch.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The freshly fetched images configuration.
    ///
    @discardableResult
    func refresh() async throws(TMDbError) -> ImagesConfiguration

}
