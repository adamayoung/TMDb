//
//  ImagesConfiguration+URLs.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public extension ImagesConfiguration {

    ///
    /// Generates the fully qualified URL for a backdrop image.
    ///
    /// - Parameters:
    ///   - path: Path to the backdrop image.
    ///   - width: The ideal width of the image. The actual image maybe be larger. When no width is given, the original
    ///            image URL is returned.
    ///
    /// - Returns: A fully qualified URL to a backdrop image.
    ///
    func backdropURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        imageURL(for: path, idealWidth: width, sizes: backdropSizes)
    }

    ///
    /// Generates the fully qualified URL for a logo image.
    ///
    /// - Parameters:
    ///   - path: Path to the logo image.
    ///   - width: The ideal width of the image. The actual image maybe be larger. When no width is given, the original
    ///            image URL is returned.
    ///
    /// - Returns: A fully qualified URL to a logo image.
    ///
    func logoURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        imageURL(for: path, idealWidth: width, sizes: logoSizes)
    }

    ///
    /// Generates the fully qualified URL for a poster image.
    ///
    /// - Parameters:
    ///   - path: Path to the poster image.
    ///   - width: The ideal width of the image. The actual image maybe be larger. When no width is given, the original
    ///            image URL is returned.
    ///
    /// - Returns: A fully qualified URL to a poster image.
    ///
    func posterURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        imageURL(for: path, idealWidth: width, sizes: posterSizes)
    }

    ///
    /// Generates the fully qualified URL for a profile image.
    ///
    /// - Parameters:
    ///   - path: Path to the profile image.
    ///   - width: The ideal width of the image. The actual image maybe be larger. When no width is given, the original
    ///            image URL is returned.
    ///
    /// - Returns: A fully qualified URL to a profile image.
    ///
    func profileURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        imageURL(for: path, idealWidth: width, sizes: profileSizes)
    }

    ///
    /// Generates the fully qualified URL for a still image.
    ///
    /// - Parameters:
    ///   - path: Path to the still image.
    ///   - width: The ideal width of the image. The actual image maybe be larger. When no width is given, the original
    ///            image URL is returned.
    ///
    /// - Returns: A fully qualified URL to a still image.
    ///
    func stillURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        imageURL(for: path, idealWidth: width, sizes: stillSizes)
    }

}

public extension ImagesConfiguration {

    ///
    /// Generates the fully qualified URL for a backdrop image at a specific size.
    ///
    /// - Parameters:
    ///   - path: Path to the backdrop image.
    ///   - size: The desired image size. ``ImageSize/original`` is always supported; any other
    ///           size must be present in ``backdropSizes``.
    ///
    /// - Returns: A fully qualified URL to a backdrop image, or `nil` if `path` is `nil` or the
    ///            size is not supported.
    ///
    func backdropURL(for path: URL?, size: ImageSize) -> URL? {
        imageURL(for: path, size: size, sizes: backdropSizes)
    }

    ///
    /// Generates the fully qualified URL for a logo image at a specific size.
    ///
    /// - Parameters:
    ///   - path: Path to the logo image.
    ///   - size: The desired image size. ``ImageSize/original`` is always supported; any other
    ///           size must be present in ``logoSizes``.
    ///
    /// - Returns: A fully qualified URL to a logo image, or `nil` if `path` is `nil` or the size
    ///            is not supported.
    ///
    func logoURL(for path: URL?, size: ImageSize) -> URL? {
        imageURL(for: path, size: size, sizes: logoSizes)
    }

    ///
    /// Generates the fully qualified URL for a poster image at a specific size.
    ///
    /// - Parameters:
    ///   - path: Path to the poster image.
    ///   - size: The desired image size. ``ImageSize/original`` is always supported; any other
    ///           size must be present in ``posterSizes``.
    ///
    /// - Returns: A fully qualified URL to a poster image, or `nil` if `path` is `nil` or the
    ///            size is not supported.
    ///
    func posterURL(for path: URL?, size: ImageSize) -> URL? {
        imageURL(for: path, size: size, sizes: posterSizes)
    }

    ///
    /// Generates the fully qualified URL for a profile image at a specific size.
    ///
    /// - Parameters:
    ///   - path: Path to the profile image.
    ///   - size: The desired image size. ``ImageSize/original`` is always supported; any other
    ///           size must be present in ``profileSizes``.
    ///
    /// - Returns: A fully qualified URL to a profile image, or `nil` if `path` is `nil` or the
    ///            size is not supported.
    ///
    func profileURL(for path: URL?, size: ImageSize) -> URL? {
        imageURL(for: path, size: size, sizes: profileSizes)
    }

    ///
    /// Generates the fully qualified URL for a still image at a specific size.
    ///
    /// - Parameters:
    ///   - path: Path to the still image.
    ///   - size: The desired image size. ``ImageSize/original`` is always supported; any other
    ///           size must be present in ``stillSizes``.
    ///
    /// - Returns: A fully qualified URL to a still image, or `nil` if `path` is `nil` or the size
    ///            is not supported.
    ///
    func stillURL(for path: URL?, size: ImageSize) -> URL? {
        imageURL(for: path, size: size, sizes: stillSizes)
    }

}

extension ImagesConfiguration {

    private static let defaultSizePathComponent = "original"

    private func imageURL(for path: URL?, idealWidth width: Int, sizes: [String]) -> URL? {
        guard let path else {
            return nil
        }

        let sizePathComponent = Self.imageSizePathComponent(for: width, from: sizes)

        return
            secureBaseURL
                .appending(path: sizePathComponent)
                .appending(path: path.absoluteString)
    }

    private func imageURL(for path: URL?, size: ImageSize, sizes: [String]) -> URL? {
        guard let path else {
            return nil
        }

        let sizePathComponent = size.pathComponent
        guard size == .original || sizes.contains(sizePathComponent) else {
            return nil
        }

        return
            secureBaseURL
                .appending(path: sizePathComponent)
                .appending(path: path.absoluteString)
    }

    private static func imageSizePathComponent(for width: Int, from sizes: [String]) -> String {
        let actualSize =
            sizes.first { size in
                guard let parsedSize = Int(size.replacingOccurrences(of: "w", with: "")) else {
                    return false
                }

                return parsedSize >= width
            } ?? sizes.last

        return actualSize ?? Self.defaultSizePathComponent
    }

}
