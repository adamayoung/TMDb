import Foundation

struct TwitterLink: ExternalLink {

    let id: String
    let url: URL

    init?(twitterID: String) {
        self.id = twitterID

        guard let url = Self.twitterURL(for: twitterID) else {
            return nil
        }

        self.url = url
    }

}

extension TwitterLink {

    private static func twitterURL(for twitterID: String) -> URL? {
        URL(string: "https://www.twitter.com/\(twitterID)")
    }

}
