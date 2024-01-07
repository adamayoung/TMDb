import Foundation

///
/// A TikTok external link.
///
/// e.g. to a person's TikTok profile.
///
public struct TikTokLink: ExternalLink {

    ///
    /// TikTok profile identifier.
    ///
    public let id: String

    ///
    /// URL of the TikTok profile page.
    ///
    public let url: URL

    ///
    /// Creates a TikTok link object using a TikTok user identifier.
    ///
    /// - Parameter tikTokID: The TikTok user identifier.
    ///
    public init?(tikTokID: String?) {
        guard
            let tikTokID,
            let url = Self.tikTokURL(for: tikTokID)
        else {
            return nil
        }

        self.init(id: tikTokID, url: url)
    }

}

extension TikTokLink {

    private init(id: String, url: URL) {
        self.id = id
        self.url = url
    }

}

extension TikTokLink {

    private static func tikTokURL(for tikTokID: String) -> URL? {
        URL(string: "https://www.tiktok.com/@\(tikTokID)")
    }

}
