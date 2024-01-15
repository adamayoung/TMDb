import Foundation

///
/// An IMDb external link.
///
/// e.g. to a movie's IMDb page.
///
public struct IMDbLink: ExternalLink {

    ///
    /// IMDb identifier.
    ///
    public let id: String

    ///
    /// URL of the IMDb web page.
    ///
    public let url: URL

    ///
    /// Creates an IMDb link object using an IMDb title identifier.
    ///
    /// e.g. for a movie or TV series.
    ///
    /// - Parameter imdbTitleID: The IMDb movie or TV series identifier.
    ///
    public init?(imdbTitleID: String?) {
        guard
            let imdbTitleID,
            let url = Self.imdbURL(forTitle: imdbTitleID)
        else {
            return nil
        }

        self.init(id: imdbTitleID, url: url)
    }

    ///
    /// Creates an IMDb link object using an IMDb name identifier.
    ///
    /// e.g. for a person.
    ///
    /// - Parameter imdbNameID: The IMDb person identifier.
    ///
    public init?(imdbNameID: String?) {
        guard
            let imdbNameID,
            let url = Self.imdbURL(forName: imdbNameID)
        else {
            return nil
        }

        self.init(id: imdbNameID, url: url)
    }

}

extension IMDbLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension IMDbLink {

    private static func imdbURL(forTitle imdbTitleID: String) -> URL? {
        URL(string: "https://www.imdb.com/title/\(imdbTitleID)/")
    }

    private static func imdbURL(forName nameID: String) -> URL? {
        URL(string: "https://www.imdb.com/name/\(nameID)/")
    }

}
