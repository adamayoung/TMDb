import Foundation

/// Provides URLs for the different sizes of backdrop images.
public protocol BackdropURLProviding {

    /// Path to the backdrop image.
    var backdropPath: URL? { get }

}

public extension BackdropURLProviding {

    /// Original backdrop image URL.
    var backdropOriginalURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(backdropPath.absoluteString)
    }

    /// Large backdrop image URL.
    var backdropLargeURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w1280")
            .appendingPathComponent(backdropPath.absoluteString)
    }

    /// Medium backdrop image URL.
    var backdropMediumURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w780")
            .appendingPathComponent(backdropPath.absoluteString)
    }

    /// Small backdrop image URL.
    var backdropSmallURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w300")
            .appendingPathComponent(backdropPath.absoluteString)
    }

    /// Aspect ratio of the backdrop image.
    static var backdropAspectRatio: Double {
        500.0 / 281.0
    }

}
