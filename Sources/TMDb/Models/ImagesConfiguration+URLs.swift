import Foundation

extension ImagesConfiguration {

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
    public func backdropURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
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
    public func logoURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
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
    public func posterURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
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
    public func profileURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
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
    public func stillURL(for path: URL?, idealWidth width: Int = Int.max) -> URL? {
        imageURL(for: path, idealWidth: width, sizes: stillSizes)
    }

}

extension ImagesConfiguration {

    private static let defaultSizePathComponent = "original"

    private func imageURL(for path: URL?, idealWidth width: Int, sizes: [String]) -> URL? {
        guard let path else {
            return nil
        }

        let sizePathComponent = Self.imageSizePathComponent(for: width, from: sizes)

        return secureBaseURL
            .appendingPathComponent(sizePathComponent)
            .appendingPathComponent(path.absoluteString)
    }

    private static func imageSizePathComponent(for width: Int, from sizes: [String]) -> String {
        let actualSize = sizes.first { size in
            guard let parsedSize = Int(size.replacingOccurrences(of: "w", with: "")) else {
                return false
            }

            return parsedSize >= width
        } ?? sizes.last

        return actualSize ?? Self.defaultSizePathComponent
    }

}
