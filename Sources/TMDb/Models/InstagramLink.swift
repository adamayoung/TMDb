import Foundation

///
/// An Instagram external link.
///
/// e.g. to a movie's Instagram profile.
///
public struct InstagramLink: ExternalLink {

    ///
    /// Instagram profile identifier.
    ///
    public let id: String

    ///
    /// URL of the Instagram profile page.
    ///
    public let url: URL

    ///
    /// Creates an Instagram link object using an Instagram profile identifier.
    ///
    /// - Parameter instagramID: The Instagram profile identifier.
    ///
    public init?(instagramID: String?) {
        guard
            let instagramID,
            let url = Self.instagramURL(for: instagramID)
        else {
            return nil
        }

        self.init(id: instagramID, url: url)
    }

}

extension InstagramLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension InstagramLink {

    private static func instagramURL(for instagramID: String) -> URL? {
        URL(string: "https://www.instagram.com/\(instagramID)")
    }

}
