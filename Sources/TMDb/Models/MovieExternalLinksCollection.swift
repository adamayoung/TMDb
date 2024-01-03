import Foundation

///
/// A model representing a collection of media databases and social IDs and links for a movie.
///
public struct MovieExternalLinksCollection: Identifiable, Codable, Equatable, Hashable {

    public let id: Movie.ID
    public let imdb: (any ExternalLink)?
    public let wikiData: (any ExternalLink)?
    public let facebook: (any ExternalLink)?
    public let instagram: (any ExternalLink)?
    public let twitter: (any ExternalLink)?

}

extension MovieExternalLinksCollection {

    private enum CodingKeys: String, CodingKey {
        case id
        case imdbID = "imdbId"
        case wikiDataID = "wikidataId"
        case facebookID = "facebookId"
        case instagramID = "instagramId"
        case twitterID = "twitterId"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(Movie.ID.self, forKey: .id)
        let imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)
        let wikiDataID = try container.decodeIfPresent(String.self, forKey: .wikiDataID)
        let facebookID = try container.decodeIfPresent(String.self, forKey: .facebookID)
        let instagramID = try container.decodeIfPresent(String.self, forKey: .instagramID)
        let twitterID = try container.decodeIfPresent(String.self, forKey: .twitterID)

        self.id = id
        self.imdb = {
            guard let imdbID else {
                return nil
            }

            return IMDbLink(imdbTitleID: imdbID)
        }()

        
    }

    public func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()

        switch self {
        case .movie(let movie):
            try singleContainer.encode(movie)

        case .tvSeries(let tvSeries):
            try singleContainer.encode(tvSeries)

        case .person(let person):
            try singleContainer.encode(person)
        }
    }

}
