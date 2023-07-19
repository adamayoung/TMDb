import Foundation

///
/// A model representing a show - movie or TV show.
///
public enum Show: Identifiable, Equatable, Hashable {

    ///
    /// Show identifier.
    ///
    public var id: Int {
        switch self {
        case .movie(let movie):
            return movie.id

        case .tvShow(let tvShow):
            return tvShow.id
        }
    }

    ///
    /// Show's popularity.
    ///
    var popularity: Double? {
        switch self {
        case .movie(let movie):
            return movie.popularity

        case .tvShow(let tvShow):
            return tvShow.popularity
        }
    }

    ///
    /// Show's release or first air date.
    ///
    var date: Date? {
        switch self {
        case .movie(let movie):
            return movie.releaseDate

        case .tvShow(let tvShow):
            return tvShow.firstAirDate
        }
    }

    ///
    /// Movie.
    ///
    case movie(Movie)

    ///
    /// TV show.
    ///
    case tvShow(TVShow)

}

extension Show: Comparable {

    public static func < (lhs: Show, rhs: Show) -> Bool {
        guard let lhsDate = lhs.date else {
            return false
        }

        guard let rhsDate = rhs.date else {
            return true
        }

        return lhsDate > rhsDate
    }

}

extension Show: Decodable {

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
            self = .movie(try Movie(from: decoder))

        case .tvShow:
            self = .tvShow(try TVShow(from: decoder))
        }
    }

}
