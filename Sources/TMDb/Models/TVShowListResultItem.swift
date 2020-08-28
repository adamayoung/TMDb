import Foundation

public struct TVShowListResultItem: Identifiable, Decodable {

    private let firstAirDateString: String?

    public let id: Int
    public let name: String
    public let originalName: String?
    public let originalLanguage: String?
    public let overview: String?
    public let genreIds: [Int]?
    public var firstAirDate: Date? {
        guard let firstAirDateString = firstAirDateString else {
            return nil
        }

        return DateFormatter.theMovieDatabase.date(from: firstAirDateString)
    }
    public let originCountry: [String]?
    public let posterPath: URL?
    public let backdropPath: URL?
    public let popularity: Float?
    public let voteAverage: Float?
    public let voteCount: Int?

    public init(id: Int, name: String, originalName: String? = nil, originalLanguage: String? = nil,
                overview: String? = nil, genreIds: [Int]? = nil, firstAirDate: Date? = nil,
                originCountry: [String]? = nil, posterPath: URL? = nil, backdropPath: URL? = nil,
                popularity: Float? = nil, voteAverage: Float? = nil, voteCount: Int? = nil) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.genreIds = genreIds
        self.firstAirDateString = {
            guard let firstAirDate = firstAirDate else {
                return nil
            }

            return DateFormatter.theMovieDatabase.string(from: firstAirDate)
        }()
        self.originCountry = originCountry
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

}

extension TVShowListResultItem {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName
        case originalLanguage
        case overview
        case genreIds
        case firstAirDateString = "firstAirDate"
        case originCountry
        case posterPath
        case backdropPath
        case popularity
        case voteAverage
        case voteCount
    }

}
