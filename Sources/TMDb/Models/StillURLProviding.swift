import Foundation

/// Provides URLs for the different sizes of still images.
public protocol StillURLProviding {

    /// Path to the still image.
    var stillPath: URL? { get }

}

public extension StillURLProviding {

    /// Original still image URL.
    var stillOriginalURL: URL? {
        guard let stillPath = stillPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(stillPath.absoluteString)
    }

    /// Large still image URL.
    var stillLargeURL: URL? {
        guard let stillPath = stillPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w300")
            .appendingPathComponent(stillPath.absoluteString)
    }

    /// Medium still image URL.
    var stillMediumURL: URL? {
        guard let stillPath = stillPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w185")
            .appendingPathComponent(stillPath.absoluteString)
    }

    /// Small still image URL.
    var stillSmallURL: URL? {
        guard let stillPath = stillPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w92")
            .appendingPathComponent(stillPath.absoluteString)
    }

    /// Still image aspect ratio.
    static var stillAspectRatio: Double {
        500.0 / 281.0
    }

}
