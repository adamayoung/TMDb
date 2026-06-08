//
//  ImageSize.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a typed image size used when generating image URLs.
///
/// TMDb exposes the available sizes for each image type as path components such as `"w500"`,
/// `"h300"` and `"original"`. This enum provides a type-safe way to request one of those sizes
/// instead of passing a raw string or an ideal width.
///
/// The available sizes for a given image type are listed in ``ImagesConfiguration`` (for example
/// ``ImagesConfiguration/posterSizes``). Requesting a size that is not available results in a
/// `nil` URL.
///
/// See <doc:/GeneratingImageURLs> for more details.
///
public enum ImageSize: Codable, Equatable, Hashable, Sendable {

    ///
    /// An image constrained to a specific width, in pixels (e.g. `"w500"`).
    ///
    case width(Int)

    ///
    /// An image constrained to a specific height, in pixels (e.g. `"h300"`).
    ///
    case height(Int)

    ///
    /// The original, unconstrained image (`"original"`).
    ///
    case original

    ///
    /// The TMDb path component representing this image size.
    ///
    /// For example, ``width(_:)`` of `500` maps to `"w500"`, ``height(_:)`` of `300` maps to
    /// `"h300"`, and ``original`` maps to `"original"`.
    ///
    public var pathComponent: String {
        switch self {
        case .width(let width):
            "w\(width)"

        case .height(let height):
            "h\(height)"

        case .original:
            "original"
        }
    }

    ///
    /// Creates an image size from a TMDb path component.
    ///
    /// - Parameter pathComponent: A TMDb size path component such as `"w500"`, `"h300"` or
    ///                            `"original"`.
    ///
    /// - Returns: An image size, or `nil` if the path component is not recognised.
    ///
    public init?(pathComponent: String) {
        if pathComponent == "original" {
            self = .original
            return
        }

        let prefix = pathComponent.prefix(1)
        let digits = String(pathComponent.dropFirst())
        guard let value = Int(digits), value > 0, String(value) == digits else {
            return nil
        }

        switch prefix {
        case "w":
            self = .width(value)

        case "h":
            self = .height(value)

        default:
            return nil
        }
    }

}

public extension ImageSize {

    ///
    /// Creates an image size by decoding a TMDb path component string.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError` if the value is not a recognised size path component.
    ///
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let pathComponent = try container.decode(String.self)

        guard let imageSize = ImageSize(pathComponent: pathComponent) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unrecognised image size path component: \(pathComponent)"
            )
        }

        self = imageSize
    }

    ///
    /// Encodes this image size as its TMDb path component string.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - Throws: An error if encoding fails.
    ///
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(pathComponent)
    }

}
