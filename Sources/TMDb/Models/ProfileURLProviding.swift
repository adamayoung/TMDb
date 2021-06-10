import Foundation

/// Provides URLs for the different sizes of profile images.
public protocol ProfileURLProviding {

    /// Path to the profile image.
    var profilePath: URL? { get }

}

public extension ProfileURLProviding {

    /// Original profile image URL.
    var profileOriginalURL: URL? {
        guard let profilePath = profilePath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(profilePath.absoluteString)
    }

    /// Large profile image URL.
    var profileLargeURL: URL? {
        guard let profilePath = profilePath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("h632")
            .appendingPathComponent(profilePath.absoluteString)
    }

    /// Medium profile image URL.
    var profileMediumURL: URL? {
        guard let profilePath = profilePath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w185")
            .appendingPathComponent(profilePath.absoluteString)
    }

    /// Small profile image URL.
    var profileSmallURL: URL? {
        guard let profilePath = profilePath else {
            return nil
        }

        return URL.tmdbImageBaseURL
            .appendingPathComponent("w45")
            .appendingPathComponent(profilePath.absoluteString)
    }

    /// Profile image aspect ratio.
    static var profileAspectRatio: Double {
        100.0 / 150.0
    }

}
