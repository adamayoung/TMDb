import Foundation

/// Represents a movie, tv show or person.
public enum Media: Identifiable, Codable, Equatable, Hashable {

    /// Media's identifier.
    public var id: Int {
        switch self {
        case .movie(let movie):
            return movie.id

        case .tvShow(let tvShow):
            return tvShow.id

        case .person(let person):
            return person.id
        }
    }

    /// Movie.
    case movie(Movie)
    /// TV show.
    case tvShow(TVShow)
    /// Person.
    case person(Person)

}

extension Media {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable, Equatable {
        case movie
        case tvShow = "tv"
        case person
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = .movie(try Movie(from: decoder))

        case .tvShow:
            self = .tvShow(try TVShow(from: decoder))

        case .person:
            self = .person(try Person(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()

        switch self {
        case .movie(let movie):
            try singleContainer.encode(movie)

        case .tvShow(let tvShow):
            try singleContainer.encode(tvShow)

        case .person(let person):
            try singleContainer.encode(person)
        }
    }

}
