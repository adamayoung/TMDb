import Foundation

struct IMDbLink: ExternalLink {

    let id: String
    let url: URL

    init?(imdbTitleID: String?) {
        guard let imdbTitleID else {
            return nil
        }

        self.id = imdbTitleID

        guard let url = Self.imdbURL(forTitle: imdbTitleID) else {
            return nil
        }

        self.url = url
    }

    init?(imdbNameID: String) {
        self.id = imdbNameID

        guard let url = Self.imdbURL(forName: imdbNameID) else {
            return nil
        }

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
