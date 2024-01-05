import Foundation

///
/// A WikiData external link.
///
/// e.g. to a movie's WikiData page.
///
public struct WikiDataLink: ExternalLink {

    ///
    /// WikiData page identifier.
    ///
    public let id: String

    ///
    /// URL of the WikiData web page.
    ///
    public let url: URL

    ///
    /// Creates a WikiData link object using a WikiData page identifier.
    ///
    /// - Parameter wikiDataID: The WikiData page identifier.
    ///
    public init?(wikiDataID: String?) {
        guard
            let wikiDataID,
            let url = Self.wikiDataURL(for: wikiDataID)
        else {
            return nil
        }

        self.init(id: wikiDataID, url: url)
    }

}

extension WikiDataLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension WikiDataLink {

    private static func wikiDataURL(for id: String) -> URL? {
        URL(string: "https://www.wikidata.org/wiki/\(id)")
    }

}
