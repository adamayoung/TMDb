//
//  ImageProviding.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A type that provides a poster image path.
///
/// Conforming types gain a convenience method to generate a fully qualified poster image URL from
/// an ``ImagesConfiguration``.
///
public protocol PosterImageProviding: Sendable {

    ///
    /// The path to the poster image.
    ///
    var posterPath: URL? { get }

}

public extension PosterImageProviding {

    ///
    /// Generates the fully qualified URL for this item's poster image at a specific size.
    ///
    /// - Parameters:
    ///   - configuration: The images configuration used to build the URL.
    ///   - size: The desired image size. Defaults to ``ImageSize/original``, which is always
    ///           supported; any other size must be present in
    ///           ``ImagesConfiguration/posterSizes``.
    ///
    /// - Returns: A fully qualified URL to the poster image, or `nil` if there is no poster path
    ///            or the size is not supported.
    ///
    func posterURL(using configuration: ImagesConfiguration, size: ImageSize = .original) -> URL? {
        configuration.posterURL(for: posterPath, size: size)
    }

}

///
/// A type that provides a backdrop image path.
///
/// Conforming types gain a convenience method to generate a fully qualified backdrop image URL
/// from an ``ImagesConfiguration``.
///
public protocol BackdropImageProviding: Sendable {

    ///
    /// The path to the backdrop image.
    ///
    var backdropPath: URL? { get }

}

public extension BackdropImageProviding {

    ///
    /// Generates the fully qualified URL for this item's backdrop image at a specific size.
    ///
    /// - Parameters:
    ///   - configuration: The images configuration used to build the URL.
    ///   - size: The desired image size. Defaults to ``ImageSize/original``, which is always
    ///           supported; any other size must be present in
    ///           ``ImagesConfiguration/backdropSizes``.
    ///
    /// - Returns: A fully qualified URL to the backdrop image, or `nil` if there is no backdrop
    ///            path or the size is not supported.
    ///
    func backdropURL(using configuration: ImagesConfiguration, size: ImageSize = .original) -> URL? {
        configuration.backdropURL(for: backdropPath, size: size)
    }

}

///
/// A type that provides a profile image path.
///
/// Conforming types gain a convenience method to generate a fully qualified profile image URL
/// from an ``ImagesConfiguration``.
///
public protocol ProfileImageProviding: Sendable {

    ///
    /// The path to the profile image.
    ///
    var profilePath: URL? { get }

}

public extension ProfileImageProviding {

    ///
    /// Generates the fully qualified URL for this item's profile image at a specific size.
    ///
    /// - Parameters:
    ///   - configuration: The images configuration used to build the URL.
    ///   - size: The desired image size. Defaults to ``ImageSize/original``, which is always
    ///           supported; any other size must be present in
    ///           ``ImagesConfiguration/profileSizes``.
    ///
    /// - Returns: A fully qualified URL to the profile image, or `nil` if there is no profile
    ///            path or the size is not supported.
    ///
    func profileURL(using configuration: ImagesConfiguration, size: ImageSize = .original) -> URL? {
        configuration.profileURL(for: profilePath, size: size)
    }

}

///
/// A type that provides a logo image path.
///
/// Conforming types gain a convenience method to generate a fully qualified logo image URL from
/// an ``ImagesConfiguration``.
///
public protocol LogoImageProviding: Sendable {

    ///
    /// The path to the logo image.
    ///
    var logoPath: URL? { get }

}

public extension LogoImageProviding {

    ///
    /// Generates the fully qualified URL for this item's logo image at a specific size.
    ///
    /// - Parameters:
    ///   - configuration: The images configuration used to build the URL.
    ///   - size: The desired image size. Defaults to ``ImageSize/original``, which is always
    ///           supported; any other size must be present in
    ///           ``ImagesConfiguration/logoSizes``.
    ///
    /// - Returns: A fully qualified URL to the logo image, or `nil` if there is no logo path or
    ///            the size is not supported.
    ///
    func logoURL(using configuration: ImagesConfiguration, size: ImageSize = .original) -> URL? {
        configuration.logoURL(for: logoPath, size: size)
    }

}

///
/// A type that provides a still image path.
///
/// Conforming types gain a convenience method to generate a fully qualified still image URL from
/// an ``ImagesConfiguration``.
///
public protocol StillImageProviding: Sendable {

    ///
    /// The path to the still image.
    ///
    var stillPath: URL? { get }

}

public extension StillImageProviding {

    ///
    /// Generates the fully qualified URL for this item's still image at a specific size.
    ///
    /// - Parameters:
    ///   - configuration: The images configuration used to build the URL.
    ///   - size: The desired image size. Defaults to ``ImageSize/original``, which is always
    ///           supported; any other size must be present in
    ///           ``ImagesConfiguration/stillSizes``.
    ///
    /// - Returns: A fully qualified URL to the still image, or `nil` if there is no still path or
    ///            the size is not supported.
    ///
    func stillURL(using configuration: ImagesConfiguration, size: ImageSize = .original) -> URL? {
        configuration.stillURL(for: stillPath, size: size)
    }

}
