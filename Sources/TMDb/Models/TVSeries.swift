import Foundation

///
/// A model representing a TV series.
///
public struct TVSeries: Identifiable, Codable, Equatable, Hashable {

    ///
    /// TV series identifier.
    ///
    public let id: Int

    ///
    /// TV series name.
    ///
    public let name: String

    ///
    /// TV series tagline.
    ///
    public let tagline: String?

    ///
    /// Original TV series name.
    ///
    public let originalName: String?

    ///
    /// Original language of the TV series.
    ///
    public let originalLanguage: String?

    ///
    /// TV series overview.
    ///
    public let overview: String?

    ///
    /// TV series episode run times, in minutes.
    ///
    public let episodeRunTime: [Int]?

    ///
    /// Number of seasons in the TV series.
    ///
    public let numberOfSeasons: Int?

    ///
    /// Total number of episodes in the TV series.
    ///
    public let numberOfEpisodes: Int?

    ///
    /// Seasons in the TV series.
    ///
    public let seasons: [TVSeason]?

    ///
    /// TV series genres.
    ///
    public let genreIds: [Int]?

    ///
    /// TV series' first air date.
    ///
    public let firstAirDate: Date?

    ///
    /// TV series country of origin.
    ///
    public let originCountry: [String]?

    ///
    /// TV series poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// TV series backdrop path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let backdropPath: URL?

    ///
    /// TV series' web site URL.
    ///
    public let homepageURL: URL?

    ///
    /// Is the TV series currently in production.
    ///
    public let isInProduction: Bool?

    ///
    /// Languages the TV series is available in.
    ///
    public let languages: [String]?

    ///
    /// Last air date of the TV series.
    ///
    public let lastAirDate: Date?

    ///
    /// Networks involved in the TV series.
    ///
    public let networks: [Network]?

    ///
    /// Production companies involved in the TV series.
    ///
    public let productionCompanies: [ProductionCompany]?

    ///
    /// TV series status.
    ///
    public let status: String?

    ///
    /// TV series type.
    ///
    public let type: String?

    ///
    /// TV series current popularity.
    ///
    public let popularity: Double?

    ///
    /// Average vote score.
    ///
    public let voteAverage: Double?

    ///
    /// Number of votes.
    ///
    public let voteCount: Int?

    ///
    /// Is the TV series only suitable for adults.
    ///
    public let isAdultOnly: Bool?

    ///
    /// Creates a TV series object.
    ///
    /// - Parameters:
    ///    - id: TV series identifier.
    ///    - name: TV series name.
    ///    - tagline: TV series tagline.
    ///    - originalName: Original TV series name.
    ///    - originalLanguage: Original language of the TV series.
    ///    - overview: TV series overview.
    ///    - episodeRunTime: TV series episode run times, in minutes.
    ///    - numberOfSeasons: Number of seasons in the TV series.
    ///    - numberOfEpisodes: Total number of episodes in the TV series.
    ///    - seasons: Seasons in the TV series.
    ///    - genres: TV series genres.
    ///    - firstAirDate: TV series's first air date.
    ///    - originCountry: TV series country of origin.
    ///    - posterPath: TV series poster path.
    ///    - backdropPath: TV series backdrop path.
    ///    - homepageURL: TV series's web site URL.
    ///    - isInProduction: Is TV series currently in production.
    ///    - languages: Languages the TV series is available in.
    ///    - lastAirDate: Last air date of the TV series.
    ///    - networks: Networks involved in the TV series.
    ///    - productionCompanies: Production companies involved in the TV series.
    ///    - status: TV series status.
    ///    - popularity: TV series current popularity.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    ///    - isAdultOnly: Is the TV series only suitable for adults.
    ///
    public init(
        id: Int,
        name: String,
        tagline: String? = nil,
        originalName: String? = nil,
        originalLanguage: String? = nil,
        overview: String? = nil,
        episodeRunTime: [Int]? = nil,
        numberOfSeasons: Int? = nil,
        numberOfEpisodes: Int? = nil,
        seasons: [TVSeason]? = nil,
        genres: [Int]? = nil,
        firstAirDate: Date? = nil,
        originCountry: [String]? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        homepageURL: URL? = nil,
        isInProduction: Bool? = nil,
        languages: [String]? = nil,
        lastAirDate: Date? = nil,
        networks: [Network]? = nil,
        productionCompanies: [ProductionCompany]? = nil,
        status: String? = nil,
        type: String? = nil,
        popularity: Double? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        isAdultOnly: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.tagline = tagline
        self.originalName = originalName
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.episodeRunTime = episodeRunTime
        self.numberOfSeasons = numberOfSeasons
        self.numberOfEpisodes = numberOfEpisodes
        self.seasons = seasons
        self.genreIds = genres
        self.firstAirDate = firstAirDate
        self.originCountry = originCountry
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.homepageURL = homepageURL
        self.isInProduction = isInProduction
        self.languages = languages
        self.lastAirDate = lastAirDate
        self.networks = networks
        self.productionCompanies = productionCompanies
        self.status = status
        self.type = type
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.isAdultOnly = isAdultOnly
    }

}

extension TVSeries {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case tagline
        case originalName
        case originalLanguage
        case overview
        case episodeRunTime
        case numberOfSeasons
        case numberOfEpisodes
        case seasons
        case genreIds
        case originCountry
        case posterPath
        case backdropPath
        case isInProduction = "inProduction"
        case languages
        case lastAirDate
        case networks
        case productionCompanies
        case status
        case type
        case popularity
        case voteAverage
        case voteCount
        case firstAirDate
        case homepageURL = "homepage"
        case isAdultOnly = "adult"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let container2 = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        self.originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.episodeRunTime = try container.decodeIfPresent([Int].self, forKey: .episodeRunTime)
        self.numberOfSeasons = try container.decodeIfPresent(Int.self, forKey: .numberOfSeasons)
        self.numberOfEpisodes = try container.decodeIfPresent(Int.self, forKey: .numberOfEpisodes)
        self.seasons = try container.decodeIfPresent([TVSeason].self, forKey: .seasons)
        self.genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds)

        // Need to deal with empty strings - date decoding will fail with an empty string
        let firstAirDateString = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
        self.firstAirDate = try {
            guard let firstAirDateString, !firstAirDateString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(Date.self, forKey: .firstAirDate)
        }()

        self.originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry)
        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(URL.self, forKey: .backdropPath)

        // Need to deal with empty strings - URL decoding will fail with an empty string
        let homepageURLString = try container.decodeIfPresent(String.self, forKey: .homepageURL)
        self.homepageURL = try {
            guard let homepageURLString, !homepageURLString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(URL.self, forKey: .homepageURL)
        }()

        self.isInProduction = try container.decodeIfPresent(Bool.self, forKey: .isInProduction)
        self.languages = try container.decodeIfPresent([String].self, forKey: .languages)
        self.lastAirDate = try container.decodeIfPresent(Date.self, forKey: .lastAirDate)
        self.networks = try container.decodeIfPresent([Network].self, forKey: .networks)
        self.productionCompanies = try container.decodeIfPresent([ProductionCompany].self, forKey: .productionCompanies)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.isAdultOnly = try container.decodeIfPresent(Bool.self, forKey: .isAdultOnly)
    }

}
