import Foundation

public enum ShowDTO: Identifiable, Equatable {

    public var id: Int {
        switch self {
        case .movie(let movie):
            return movie.id

        case .tvShow(let tvShow):
            return tvShow.id
        }
    }

    var popularity: Float? {
        switch self {
        case .movie(let movie):
            return movie.popularity

        case .tvShow(let tvShow):
            return tvShow.popularity
        }
    }

    var date: Date? {
        switch self {
        case .movie(let movie):
            return movie.releaseDate

        case .tvShow(let tvShow):
            return tvShow.firstAirDate
        }
    }

    case movie(MovieDTO)
    case tvShow(TVShowDTO)

}

extension ShowDTO: Decodable {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable, Equatable {
        case movie
        case tvShow = "tv"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = .movie(try MovieDTO(from: decoder))

        case .tvShow:
            self = .tvShow(try TVShowDTO(from: decoder))
        }
    }

}
