import Foundation

///
/// A model representing a TV show.
///
public struct TVShow: Identifiable, Codable, Equatable, Hashable {

    ///
    /// TV show identifier.
    ///
    public let id: Int

    ///
    /// TV show name.
    ///
    public let name: String
    
    ///
    /// TV show tagline.
    ///
    public let tagline: String?

    ///
    /// Original TV show name.
    ///
    public let originalName: String?

    ///
    /// Original language of the TV show.
    ///
    public let originalLanguage: String?

    ///
    /// TV show overview.
    ///
    public let overview: String?

    ///
    /// TV show episode run times, in minutes.
    ///
    public let episodeRunTime: [Int]?

    ///
    /// Number of seasons in the TV show.
    ///
    public let numberOfSeasons: Int?

    ///
    /// Total number of episodes in the TV show.
    ///
    public let numberOfEpisodes: Int?

    ///
    /// Seasons in the TV show.
    ///
    public let seasons: [TVShowSeason]?

    ///
    /// TV show genres.
    ///
    public let genres: [Genre]?

    ///
    /// TV show's first air date.
    ///
    public let firstAirDate: Date?

    ///
    /// TV show country of origin.
    ///
    public let originCountry: [String]?

    ///
    /// TV show poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// TV show backdrop path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let backdropPath: URL?

    ///
    /// TV show's web site URL.
    ///
    public let homepageURL: URL?

    ///
    /// Is the TV show currently in production.
    ///
    public let isInProduction: Bool?

    ///
    /// Languages the TV show is available in.
    ///
    public let languages: [String]?

    ///
    /// Last air date of the TV show.
    ///
    public let lastAirDate: Date?

    ///
    /// Networks involved in the TV show.
    ///
    public let networks: [Network]?

    ///
    /// Production companies involved in the TV show.
    ///
    public let productionCompanies: [ProductionCompany]?

    ///
    /// TV show status.
    ///
    public let status: String?

    ///
    /// TV show type.
    ///
    public let type: String?

    ///
    /// TV show current popularity.
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
    /// Is the TV show only suitable for adults.
    ///
    public let isAdultOnly: Bool?

    ///
    /// Creates a TV show object.
    ///
    /// - Parameters:
    ///    - id: TV show identifier.
    ///    - name: TV show name.
    ///    - tagline: TV show tagline.
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
    ///    - isInProduction: Is TV show currently in production.
    ///    - languages: Languages the TV show is available in.
    ///    - lastAirDate: Last air date of the TV show.
    ///    - networks: Networks involved in the TV show.
    ///    - productionCompanies: Production companies involved in the TV show.
    ///    - status: TV show status.
    ///    - popularity: TV show current popularity.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    ///    - isAdultOnly: Is the TV show only suitable for adults.
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
        seasons: [TVShowSeason]? = nil,
        genres: [Genre]? = nil,
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
        self.genres = genres
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

extension TVShow {

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
        case genres
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
        self.seasons = try container.decodeIfPresent([TVShowSeason].self, forKey: .seasons)
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)

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
