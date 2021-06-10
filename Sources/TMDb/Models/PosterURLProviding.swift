import Foundation

public protocol PosterURLProviding {

    var posterPath: URL? { get }

}

public extension PosterURLProviding {

    var posterOriginalURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(posterPath.absoluteString)
    }

    var posterLargeURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w780")
            .appendingPathComponent(posterPath.absoluteString)
    }

    var posterMediumURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w342")
            .appendingPathComponent(posterPath.absoluteString)
    }

    var posterSmallURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w154")
            .appendingPathComponent(posterPath.absoluteString)
    }

    static var posterAspectRatio: Double {
        100.0 / 150.0
    }

}
