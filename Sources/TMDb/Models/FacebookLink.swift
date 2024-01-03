import Foundation

struct FacebookLink: ExternalLink {

    let id: String
    let url: URL

    init?(facebookID: String) {
        self.id = facebookID

        guard let url = Self.facebookURL(for: facebookID) else {
            return nil
        }

        self.url = url
    }

}

extension FacebookLink {

    private static func facebookURL(for facebookID: String) -> URL? {
        URL(string: "https://www.facebook.com/\(facebookID)")
    }

}
