import Foundation

///
/// A Twitter external link.
///
/// e.g. to a movie's Twitter profile.
///
public struct TwitterLink: ExternalLink {

    ///
    /// Twitter profile identifier.
    ///
    public let id: String

    ///
    /// URL of the Twitter profile page.
    ///
    public let url: URL

    ///
    /// Creates a Twitter link object using a Twitter profile identifier.
    ///
    /// - Parameter twitterID: The Twitter profile identifier.
    ///
    public init?(twitterID: String?) {
        guard
            let twitterID,
            let url = Self.twitterURL(for: twitterID)
        else {
            return nil
        }

        self.init(id: twitterID, url: url)
    }

}

extension TwitterLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension TwitterLink {

    private static func twitterURL(for twitterID: String) -> URL? {
        URL(string: "https://www.twitter.com/\(twitterID)")
    }

}
