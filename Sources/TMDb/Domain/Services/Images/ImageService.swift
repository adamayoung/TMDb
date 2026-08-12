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
/// - Important: A caller that **suspends** on the shared fetch and is then
///   cancelled abandons its wait and throws ``TMDbError/cancelled``. The fetch
///   itself is never cancelled on that caller's behalf — it runs on, delivers to
///   every other caller waiting on it, and caches its result — because
///   cancelling it for one uninterested caller would fail all the others.
///
///   A caller served from the **cache** never suspends, so it cannot observe the
///   cancellation and returns its value as normal.
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
    /// Fetches the images configuration again, replacing the cached value once a
    /// fresh one arrives.
    ///
    /// TMDb's images configuration changes rarely, so this is seldom needed — it
    /// exists for long-lived processes that would otherwise hold one value
    /// indefinitely.
    ///
    /// The cached value is replaced only on success: if the refresh fails, the
    /// previously cached configuration is kept, so a transient network failure
    /// during a refresh does not degrade later image URLs. Callers using
    /// ``imagesConfiguration()`` meanwhile continue to receive the cached value
    /// rather than waiting for the refresh.
    ///
    /// A fetch already in progress when this is called is left running rather
    /// than cancelled, so callers waiting on it still receive its value.
    ///
    /// Unlike the URL resolvers and ``imagesConfiguration()``, this always
    /// fetches — a warm cache does not exempt it — so it throws
    /// ``TMDbError/cancelled`` when the calling task is already cancelled,
    /// without perturbing any fetch in flight.
    ///
    /// Concurrent calls to this method share a single fetch. That fetch may have
    /// been issued fractionally before a given call, so a change made in that
    /// window is not guaranteed to be reflected in the value it returns.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The freshly fetched images configuration.
    ///
    @discardableResult
    func refresh() async throws(TMDbError) -> ImagesConfiguration

}
