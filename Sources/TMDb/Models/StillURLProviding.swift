import Foundation

public protocol StillURLProviding {

    var stillPath: URL? { get }

}

public extension StillURLProviding {

    var stillOriginalURL: URL? {
        guard let stillPath = stillPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(stillPath.absoluteString)
    }

    var stillLargeURL: URL? {
        guard let stillPath = stillPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w300")
            .appendingPathComponent(stillPath.absoluteString)
    }

    var stillMediumURL: URL? {
        guard let stillPath = stillPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w185")
            .appendingPathComponent(stillPath.absoluteString)
    }

    var stillSmallURL: URL? {
        guard let stillPath = stillPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w92")
            .appendingPathComponent(stillPath.absoluteString)
    }

    static var stillAspectRatio: Float {
        500 / 281
    }

}
