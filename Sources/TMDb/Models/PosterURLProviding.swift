import Foundation

/// Provides URLs for the different sizes of poster images.
public protocol PosterURLProviding {

    /// Path to the poster image.
    var posterPath: URL? { get }

}

public extension PosterURLProviding {

    /// Original poster image URL.
    var posterOriginalURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(posterPath.absoluteString)
    }

    /// Large poster image URL.
    var posterLargeURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w780")
            .appendingPathComponent(posterPath.absoluteString)
    }

    /// Medium poster image URL.
    var posterMediumURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w342")
            .appendingPathComponent(posterPath.absoluteString)
    }

    /// Small poster image URL.
    var posterSmallURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w154")
            .appendingPathComponent(posterPath.absoluteString)
    }

    /// Poster image aspect ratio.
    static var posterAspectRatio: Double {
        100.0 / 150.0
    }

}
