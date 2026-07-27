//
//  ImageService+URLs.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension ImageService {

    ///
    /// Fetches and caches the images configuration ahead of its first use.
    ///
    /// Resolving an image URL fetches the configuration if it is not already
    /// cached. Call this at launch to pay that cost up front, so the first image
    /// URL resolves without a network round trip.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func preload() async throws(TMDbError) {
        _ = try await imagesConfiguration()
    }

    ///
    /// Generates the fully qualified URL for a backdrop image.
    ///
    /// - Parameters:
    ///   - path: Path to the backdrop image.
    ///   - width: The ideal width of the image. The actual image may be larger. When no width is
    ///            given, the original image URL is returned.
    ///
    /// - Throws: TMDb error ``TMDbError``. Not thrown when `path` is `nil`.
    ///
    /// - Returns: A fully qualified URL to a backdrop image, or `nil` if `path` is `nil`.
    ///
    func backdropURL(
        for path: URL?,
        idealWidth width: Int = Int.max
    ) async throws(TMDbError) -> URL? {
        guard let path else {
            return nil
        }

        return try await imagesConfiguration().backdropURL(for: path, idealWidth: width)
    }

    ///
    /// Generates the fully qualified URL for a logo image.
    ///
    /// - Parameters:
    ///   - path: Path to the logo image.
    ///   - width: The ideal width of the image. The actual image may be larger. When no width is
    ///            given, the original image URL is returned.
    ///
    /// - Throws: TMDb error ``TMDbError``. Not thrown when `path` is `nil`.
    ///
    /// - Returns: A fully qualified URL to a logo image, or `nil` if `path` is `nil`.
    ///
    func logoURL(for path: URL?, idealWidth width: Int = Int.max) async throws(TMDbError) -> URL? {
        guard let path else {
            return nil
        }

        return try await imagesConfiguration().logoURL(for: path, idealWidth: width)
    }

    ///
    /// Generates the fully qualified URL for a poster image.
    ///
    /// - Parameters:
    ///   - path: Path to the poster image.
    ///   - width: The ideal width of the image. The actual image may be larger. When no width is
    ///            given, the original image URL is returned.
    ///
    /// - Throws: TMDb error ``TMDbError``. Not thrown when `path` is `nil`.
    ///
    /// - Returns: A fully qualified URL to a poster image, or `nil` if `path` is `nil`.
    ///
    func posterURL(
        for path: URL?,
        idealWidth width: Int = Int.max
    ) async throws(TMDbError) -> URL? {
        guard let path else {
            return nil
        }

        return try await imagesConfiguration().posterURL(for: path, idealWidth: width)
    }

    ///
    /// Generates the fully qualified URL for a profile image.
    ///
    /// - Parameters:
    ///   - path: Path to the profile image.
    ///   - width: The ideal width of the image. The actual image may be larger. When no width is
    ///            given, the original image URL is returned.
    ///
    /// - Throws: TMDb error ``TMDbError``. Not thrown when `path` is `nil`.
    ///
    /// - Returns: A fully qualified URL to a profile image, or `nil` if `path` is `nil`.
    ///
    func profileURL(
        for path: URL?,
        idealWidth width: Int = Int.max
    ) async throws(TMDbError) -> URL? {
        guard let path else {
            return nil
        }

        return try await imagesConfiguration().profileURL(for: path, idealWidth: width)
    }

    ///
    /// Generates the fully qualified URL for a still image.
    ///
    /// - Parameters:
    ///   - path: Path to the still image.
    ///   - width: The ideal width of the image. The actual image may be larger. When no width is
    ///            given, the original image URL is returned.
    ///
    /// - Throws: TMDb error ``TMDbError``. Not thrown when `path` is `nil`.
    ///
    /// - Returns: A fully qualified URL to a still image, or `nil` if `path` is `nil`.
    ///
    func stillURL(for path: URL?, idealWidth width: Int = Int.max) async throws(TMDbError) -> URL? {
        guard let path else {
            return nil
        }

        return try await imagesConfiguration().stillURL(for: path, idealWidth: width)
    }

    ///
    /// Generates the fully qualified URL for a backdrop image at a specific size.
    ///
    /// - Parameters:
    ///   - path: Path to the backdrop image.
    ///   - size: The desired image size. ``ImageSize/original`` is always supported; any other
    ///           size must be present in ``ImagesConfiguration/backdropSizes``.
    ///
    /// - Throws: TMDb error ``TMDbError``. Not thrown when `path` is `nil`.
    ///
    /// - Returns: A fully qualified URL to a backdrop image, or `nil` if `path` is `nil` or the
    ///            size is not supported.
    ///
    func backdropURL(for path: URL?, size: ImageSize) async throws(TMDbError) -> URL? {
        guard let path else {
            return nil
        }

        return try await imagesConfiguration().backdropURL(for: path, size: size)
    }

    ///
    /// Generates the fully qualified URL for a logo image at a specific size.
    ///
    /// - Parameters:
    ///   - path: Path to the logo image.
    ///   - size: The desired image size. ``ImageSize/original`` is always supported; any other
    ///           size must be present in ``ImagesConfiguration/logoSizes``.
    ///
    /// - Throws: TMDb error ``TMDbError``. Not thrown when `path` is `nil`.
    ///
    /// - Returns: A fully qualified URL to a logo image, or `nil` if `path` is `nil` or the size
    ///            is not supported.
    ///
    func logoURL(for path: URL?, size: ImageSize) async throws(TMDbError) -> URL? {
        guard let path else {
            return nil
        }

        return try await imagesConfiguration().logoURL(for: path, size: size)
    }

    ///
    /// Generates the fully qualified URL for a poster image at a specific size.
    ///
    /// - Parameters:
    ///   - path: Path to the poster image.
    ///   - size: The desired image size. ``ImageSize/original`` is always supported; any other
    ///           size must be present in ``ImagesConfiguration/posterSizes``.
    ///
    /// - Throws: TMDb error ``TMDbError``. Not thrown when `path` is `nil`.
    ///
    /// - Returns: A fully qualified URL to a poster image, or `nil` if `path` is `nil` or the
    ///            size is not supported.
    ///
    func posterURL(for path: URL?, size: ImageSize) async throws(TMDbError) -> URL? {
        guard let path else {
            return nil
        }

        return try await imagesConfiguration().posterURL(for: path, size: size)
    }

    ///
    /// Generates the fully qualified URL for a profile image at a specific size.
    ///
    /// - Parameters:
    ///   - path: Path to the profile image.
    ///   - size: The desired image size. ``ImageSize/original`` is always supported; any other
    ///           size must be present in ``ImagesConfiguration/profileSizes``.
    ///
    /// - Throws: TMDb error ``TMDbError``. Not thrown when `path` is `nil`.
    ///
    /// - Returns: A fully qualified URL to a profile image, or `nil` if `path` is `nil` or the
    ///            size is not supported.
    ///
    func profileURL(for path: URL?, size: ImageSize) async throws(TMDbError) -> URL? {
        guard let path else {
            return nil
        }

        return try await imagesConfiguration().profileURL(for: path, size: size)
    }

    ///
    /// Generates the fully qualified URL for a still image at a specific size.
    ///
    /// - Parameters:
    ///   - path: Path to the still image.
    ///   - size: The desired image size. ``ImageSize/original`` is always supported; any other
    ///           size must be present in ``ImagesConfiguration/stillSizes``.
    ///
    /// - Throws: TMDb error ``TMDbError``. Not thrown when `path` is `nil`.
    ///
    /// - Returns: A fully qualified URL to a still image, or `nil` if `path` is `nil` or the size
    ///            is not supported.
    ///
    func stillURL(for path: URL?, size: ImageSize) async throws(TMDbError) -> URL? {
        guard let path else {
            return nil
        }

        return try await imagesConfiguration().stillURL(for: path, size: size)
    }

}
