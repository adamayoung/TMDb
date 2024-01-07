import Foundation

///
/// An Facebook external link.
///
/// e.g. to a movie's Facebook profile.
///
public struct FacebookLink: ExternalLink {

    ///
    /// Facebook profile identifier.
    ///
    public let id: String

    ///
    /// URL of the Facebook profile page.
    ///
    public let url: URL

    ///
    /// Creates a Facebook link object using a Facebook profile identifier.
    ///
    /// - Parameter facebookID: The Facebook profile identifier.
    ///
    public init?(facebookID: String?) {
        guard
            let facebookID,
            let url = Self.facebookURL(for: facebookID)
        else {
            return nil
        }

        self.init(id: facebookID, url: url)
    }

}

extension FacebookLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension FacebookLink {

    private static func facebookURL(for facebookID: String) -> URL? {
        URL(string: "https://www.facebook.com/\(facebookID)")
    }

}
