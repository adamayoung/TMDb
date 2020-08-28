import Foundation

public enum MultiTypeListResultItem: Identifiable {

    public var id: String {
        switch self {
        case .movie(let movie):
            return "movie-\(movie.id)"

        case .tvShow(let tvShow):
            return "tvShow-\(tvShow.id)"

        case .person(let person):
            return "person-\(person.id)"
        }
    }

    case movie(MovieListResultItem)
    case tvShow(TVShowListResultItem)
    case person(PersonListResultItem)

}

extension MultiTypeListResultItem: Decodable {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable {
        case movie
        case tvShow = "tv"
        case person
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = .movie(try MovieListResultItem(from: decoder))

        case .tvShow:
            self = .tvShow(try TVShowListResultItem(from: decoder))

        case .person:
            self = .person(try PersonListResultItem(from: decoder))
        }
    }

}
