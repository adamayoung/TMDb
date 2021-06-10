import Foundation

/// Provides URLs for the different sizes of logo images.
public protocol LogoURLProviding {

    /// Path to the logo image.
    var logoPath: URL? { get }

}

public extension LogoURLProviding {

    /// Original logo image URL.
    var logoOriginalURL: URL? {
        guard let logoPath = logoPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(logoPath.absoluteString)
    }

    /// Large logo image URL.
    var logoLargeURL: URL? {
        guard let logoPath = logoPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w500")
            .appendingPathComponent(logoPath.absoluteString)
    }

    /// Medium logo image URL.
    var logoMediumURL: URL? {
        guard let logoPath = logoPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w185")
            .appendingPathComponent(logoPath.absoluteString)
    }

    /// Small logo image URL.
    var logoSmallURL: URL? {
        guard let logoPath = logoPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w92")
            .appendingPathComponent(logoPath.absoluteString)
    }

}
