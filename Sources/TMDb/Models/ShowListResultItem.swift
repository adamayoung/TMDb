import Foundation

public enum ShowListResultItem: Identifiable {

    public var id: String {
        switch self {
        case .movie(let movie):
            return "movie-\(movie.id)"

        case .tvShow(let tvShow):
            return "tvShow-\(tvShow.id)"
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

    case movie(MovieListResultItem)
    case tvShow(TVShowListResultItem)

}

extension ShowListResultItem: Decodable {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable {
        case movie
        case tvShow = "tv"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = .movie(try MovieListResultItem(from: decoder))

        case .tvShow:
            self = .tvShow(try TVShowListResultItem(from: decoder))
        }
    }

}
