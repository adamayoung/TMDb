import Foundation

struct InstagramLink: ExternalLink {

    let id: String
    let url: URL

    init?(instagramID: String) {
        self.id = instagramID

        guard let url = Self.instagramURL(for: instagramID) else {
            return nil
        }

        self.url = url
    }

}

extension InstagramLink {

    private static func instagramURL(for instagramID: String) -> URL? {
        URL(string: "https://www.instagram.com/\(instagramID)")
    }

}
