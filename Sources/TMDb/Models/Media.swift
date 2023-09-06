import Foundation

///
/// A model representing a media.
///
public enum Media: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Media's identifier.
    ///
    public var id: Int {
        switch self {
        case .movie(let movie):
            return movie.id

        case .tvSeries(let tvSeries):
            return tvSeries.id

        case .person(let person):
            return person.id
        }
    }

    ///
    /// Movie.
    ///
    case movie(Movie)

    ///
    /// TV series.
    ///
    case tvSeries(TVSeries)

    ///
    /// Person.
    ///
    case person(Person)

}

extension Media {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable, Equatable {
        case movie
        case tvSeries = "tv"
        case person
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = .movie(try Movie(from: decoder))

        case .tvSeries:
            self = .tvSeries(try TVSeries(from: decoder))

        case .person:
            self = .person(try Person(from: decoder))
        }
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
