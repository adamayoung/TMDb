import Foundation

public protocol LogoURLProviding {

    var logoPath: URL? { get }

}

public extension LogoURLProviding {

    var logoOriginalURL: URL? {
        guard let logoPath = logoPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(logoPath.absoluteString)
    }

    var logoLargeURL: URL? {
        guard let logoPath = logoPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w500")
            .appendingPathComponent(logoPath.absoluteString)
    }

    var logoMediumURL: URL? {
        guard let logoPath = logoPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w185")
            .appendingPathComponent(logoPath.absoluteString)
    }

    var logoSmallURL: URL? {
        guard let logoPath = logoPath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w92")
            .appendingPathComponent(logoPath.absoluteString)
    }

}
