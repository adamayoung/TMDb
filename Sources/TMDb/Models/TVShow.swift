import Foundation

/// A TV show.
public struct TVShow: Identifiable, Decodable, Equatable, Hashable {

    /// TV show identifier.
    public let id: Int
    /// TV show name.
    public let name: String
    /// Original TV show name.
    public let originalName: String?
    /// Original language of the TV show.
    public let originalLanguage: String?
    /// TV show overview.
    public let overview: String?
    /// TV show episode run times, in minutes.
    public let episodeRunTime: [Int]?
    /// Number of seasons in the TV show.
    public let numberOfSeasons: Int?
    /// Total number of episodes in the TV show.
    public let numberOfEpisodes: Int?
    /// Seasons in the TV show.
    public let seasons: [TVShowSeason]?
    /// TV show genres.
    public let genres: [Genre]?
    /// TV show's first air date.
    public var firstAirDate: Date? {
        guard let firstAirDateString else {
            return nil
        }

        return DateFormatter.theMovieDatabase.date(from: firstAirDateString)
    }
    /// TV show country of origin.
    public let originCountry: [String]?
    /// TV show poster path.
    public let posterPath: URL?
    /// TV show backdrop path.
    public let backdropPath: URL?
    /// TV show's web site URL.
    public var homepageURL: URL? {
        guard let homepage else {
            return nil
        }

        return URL(string: homepage)
    }
    /// Is TV show currently in production.
    public let inProduction: Bool?
    /// Languages the TV show is available in.
    public let languages: [String]?
    /// Last air date of the TV show.
    public let lastAirDate: Date?
    /// Networks involved in the TV show.
    public let networks: [Network]?
    /// Production companies involved in the TV show.
    public let productionCompanies: [ProductionCompany]?
    /// TV show status.
    public let status: String?
    /// TV show type.
    public let type: String?
    /// TV show current popularity.
    public let popularity: Double?
    /// Average vote score.
    public let voteAverage: Double?
    /// Number of votes.
    public let voteCount: Int?

    private let firstAirDateString: String?
    private let homepage: String?

    /// Creates a new `TVShow`.
    ///
    /// - Parameters:
    ///    - id: TV show identifier.
    ///    - name: TV show name.
    ///    - originalName: Original TV show name.
    ///    - originalLanguage: Original language of the TV show.
    ///    - overview: TV show overview.
    ///    - episodeRunTime: TV show episode run times, in minutes.
    ///    - numberOfSeasons: Number of seasons in the TV show.
    ///    - numberOfEpisodes: Total number of episodes in the TV show.
    ///    - seasons: Seasons in the TV show.
    ///    - genres: TV show genres.
    ///    - firstAirDate: TV show's first air date.
    ///    - originCountry: TV show country of origin.
    ///    - posterPath: TV show poster path.
    ///    - backdropPath: TV show backdrop path.
    ///    - homepageURL: TV show's web site URL.
    ///    - inProduction: Is TV show currently in production.
    ///    - languages: Languages the TV show is available in.
    ///    - lastAirDate: Last air date of the TV show.
    ///    - networks: Networks involved in the TV show.
    ///    - productionCompanies: Production companies involved in the TV show.
    ///    - status: TV show status.
    ///    - popularity: TV show current popularity.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    public init(id: Int, name: String, originalName: String? = nil, originalLanguage: String? = nil,
                overview: String? = nil, episodeRunTime: [Int]? = nil, numberOfSeasons: Int? = nil,
                numberOfEpisodes: Int? = nil, seasons: [TVShowSeason]? = nil, genres: [Genre]? = nil,
                firstAirDate: Date? = nil, originCountry: [String]? = nil, posterPath: URL? = nil,
                backdropPath: URL? = nil, homepageURL: URL? = nil, inProduction: Bool? = nil,
                languages: [String]? = nil, lastAirDate: Date? = nil, networks: [Network]? = nil,
                productionCompanies: [ProductionCompany]? = nil, status: String? = nil, type: String? = nil,
                popularity: Double? = nil, voteAverage: Double? = nil, voteCount: Int? = nil) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.episodeRunTime = episodeRunTime
        self.numberOfSeasons = numberOfSeasons
        self.numberOfEpisodes = numberOfEpisodes
        self.seasons = seasons
        self.genres = genres
        self.firstAirDateString = {
            guard let firstAirDate else {
                return nil
            }

            return DateFormatter.theMovieDatabase.string(from: firstAirDate)
        }()
        self.originCountry = originCountry
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.homepage = homepageURL?.absoluteString
        self.inProduction = inProduction
        self.languages = languages
        self.lastAirDate = lastAirDate
        self.networks = networks
        self.productionCompanies = productionCompanies
        self.status = status
        self.type = type
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

}

extension TVShow: Comparable {

    public static func < (lhs: TVShow, rhs: TVShow) -> Bool {
        guard let lhsDate = lhs.firstAirDate else {
            return false
        }

        guard let rhsDate = rhs.firstAirDate else {
            return true
        }

        return lhsDate > rhsDate
    }

}

extension TVShow {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName
        case originalLanguage
        case overview
        case episodeRunTime
        case numberOfSeasons
        case numberOfEpisodes
        case seasons
        case genres
        case originCountry
        case posterPath
        case backdropPath
        case inProduction
        case languages
        case lastAirDate
        case networks
        case productionCompanies
        case status
        case type
        case popularity
        case voteAverage
        case voteCount
        case firstAirDateString = "firstAirDate"
        case homepage
    }

}
