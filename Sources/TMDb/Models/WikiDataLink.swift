import Foundation

struct WikiDataLink: ExternalLink {

    let id: String
    let url: URL

    init?(wikiDataID: String) {
        self.id = wikiDataID

        guard let url = Self.wikiDataURL(for: wikiDataID) else {
            return nil
        }

        self.url = url
    }

}

extension WikiDataLink {

    private static func wikiDataURL(for id: String) -> URL? {
        URL(string: "https://www.wikidata.org/wiki/\(id)")
    }

}
