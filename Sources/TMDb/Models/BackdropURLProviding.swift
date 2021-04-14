import Foundation

public protocol BackdropURLProviding {

    var backdropPath: URL? { get }

}

public extension BackdropURLProviding {

    var backdropOriginalURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(backdropPath.absoluteString)
    }

    var backdropLargeURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w1280")
            .appendingPathComponent(backdropPath.absoluteString)
    }

    var backdropMediumURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w780")
            .appendingPathComponent(backdropPath.absoluteString)
    }

    var backdropSmallURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w300")
            .appendingPathComponent(backdropPath.absoluteString)
    }

    static var backdropAspectRatio: Float {
        500 / 281
    }

}
