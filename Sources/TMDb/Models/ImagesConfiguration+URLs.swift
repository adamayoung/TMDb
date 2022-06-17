import Foundation

extension ImagesConfiguration {

    /// Generates the fully qualified URL for a backdrop image.
    ///
    /// - Parameters:
    ///   - path: Path to the backdrop image.
    ///   - width: The ideal width of the image. The actual image maybe be larger. When no width is given, the original image URL is returned.
    ///
    /// - Returns: A fully qualified URL to a backdrop image.
    public func backdropURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        let sizePathComponent = Self.imageSizePathComponent(for: width, from: backdropSizes)
        return imageURL(for: path, sizePathComponent: sizePathComponent)
    }

    /// Generates the fully qualified URL for a logo image.
    ///
    /// - Parameters:
    ///   - path: Path to the logo image.
    ///   - width: The ideal width of the image. The actual image maybe be larger. When no width is given, the original image URL is returned.
    ///
    /// - Returns: A fully qualified URL to a logo image.
    public func logoURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        let sizePathComponent = Self.imageSizePathComponent(for: width, from: logoSizes)
        return imageURL(for: path, sizePathComponent: sizePathComponent)
    }

    /// Generates the fully qualified URL for a poster image.
    ///
    /// - Parameters:
    ///   - path: Path to the poster image.
    ///   - width: The ideal width of the image. The actual image maybe be larger. When no width is given, the original image URL is returned.
    ///
    /// - Returns: A fully qualified URL to a poster image.
    public func posterURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        let sizePathComponent = Self.imageSizePathComponent(for: width, from: posterSizes)
        return imageURL(for: path, sizePathComponent: sizePathComponent)
    }

    /// Generates the fully qualified URL for a profile image.
    ///
    /// - Parameters:
    ///   - path: Path to the profile image.
    ///   - width: The ideal width of the image. The actual image maybe be larger. When no width is given, the original image URL is returned.
    ///
    /// - Returns: A fully qualified URL to a profile image.
    public func profileURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        let sizePathComponent = Self.imageSizePathComponent(for: width, from: profileSizes)
        return imageURL(for: path, sizePathComponent: sizePathComponent)
    }

    /// Generates the fully qualified URL for a still image.
    ///
    /// - Parameters:
    ///   - path: Path to the still image.
    ///   - width: The ideal width of the image. The actual image maybe be larger. When no width is given, the original image URL is returned.
    ///
    /// - Returns: A fully qualified URL to a still image.
    public func stillURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        let sizePathComponent = Self.imageSizePathComponent(for: width, from: stillSizes)
        return imageURL(for: path, sizePathComponent: sizePathComponent)
    }

}

extension ImagesConfiguration {

    private static let defaultSizePathComponent = "original"

    private func imageURL(for path: URL?, sizePathComponent: String) -> URL? {
        guard let path = path else {
            return nil
        }

        return secureBaseURL
            .appendingPathComponent(sizePathComponent)
            .appendingPathComponent(path.absoluteString)
    }

    private static func imageSizePathComponent(for width: Int, from sizes: [String]) -> String {
        for size in sizes {
            guard let parsedSize = Int(size.replacingOccurrences(of: "w", with: "")) else {
                continue
            }

            if parsedSize >= width  {
                return size
            }
        }

        return sizes.last ?? Self.defaultSizePathComponent
    }

}
