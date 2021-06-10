import Foundation

public protocol ProfileURLProviding {

    var profilePath: URL? { get }

}

public extension ProfileURLProviding {

    var profileOriginalURL: URL? {
        guard let profilePath = profilePath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(profilePath.absoluteString)
    }

    var profileLargeURL: URL? {
        guard let profilePath = profilePath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("h632")
            .appendingPathComponent(profilePath.absoluteString)
    }

    var profileMediumURL: URL? {
        guard let profilePath = profilePath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w185")
            .appendingPathComponent(profilePath.absoluteString)
    }

    var profileSmallURL: URL? {
        guard let profilePath = profilePath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w45")
            .appendingPathComponent(profilePath.absoluteString)
    }

    static var profileAspectRatio: Double {
        100.0 / 150.0
    }

}
