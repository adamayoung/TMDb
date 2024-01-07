import Foundation

///
/// A model representing a show - movie or TV series.
///
public enum Show: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Show identifier.
    ///
    public var id: Int {
        switch self {
        case .movie(let movie):
            return movie.id

        case .tvSeries(let tvSeries):
            return tvSeries.id
        }
    }

    ///
    /// Show's popularity.
    ///
    var popularity: Double? {
        switch self {
        case .movie(let movie):
            return movie.popularity

        case .tvSeries(let tvSeries):
            return tvSeries.popularity
        }
    }

    ///
    /// Show's release or first air date.
    ///
    var date: Date? {
        switch self {
        case .movie(let movie):
            return movie.releaseDate

        case .tvSeries(let tvSeries):
            return tvSeries.firstAirDate
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

}

extension Show {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable, Equatable {
        case movie
        case tvSeries = "tv"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = .movie(try Movie(from: decoder))

        case .tvSeries:
            self = .tvSeries(try TVSeries(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()

        switch self {
        case .movie(let movie):
            try singleContainer.encode(movie)

        case .tvSeries(let tvSeries):
            try singleContainer.encode(tvSeries)
        }
    }
}
