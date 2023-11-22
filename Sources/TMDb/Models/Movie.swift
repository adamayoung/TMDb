import Foundation

///
/// A model representing a movie.
///
public struct Movie: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Movie identifier.
    ///
    public let id: Int

    ///
    /// Movie title.
    ///
    public let title: String

    ///
    /// Movie tagline.
    ///
    public let tagline: String?

    ///
    /// Original movie title.
    ///
    public let originalTitle: String?

    ///
    /// Original language of the movie.
    ///
    public let originalLanguage: String?

    ///
    /// Movie overview.
    ///
    public let overview: String?

    ///
    /// Movie runtime, in minutes.
    ///
    public let runtime: Int?

    ///
    /// Movie genres.
    ///
    public let genreIds: [Int]?

    ///
    /// Movie release date.
    ///
    public let releaseDate: Date?

    ///
    /// Movie poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// Movie poster backdrop path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let backdropPath: URL?

    ///
    /// Movie budget, in US dollars.
    ///
    public let budget: Double?

    ///
    /// Movie revenue, in US dollars.
    ///
    public let revenue: Double?

    ///
    /// Movie's web site URL.
    ///
    public let homepageURL: URL?

    ///
    /// IMDd identifier.
    ///
    public let imdbID: String?

    ///
    /// Movie status.
    ///
    public let status: Status?

    ///
    /// Movie production companies.
    ///
    public let productionCompanies: [ProductionCompany]?

    ///
    /// Movie production countries.
    ///
    public let productionCountries: [ProductionCountry]?

    ///
    /// Movie spoken languages.
    ///
    public let spokenLanguages: [SpokenLanguage]?

    ///
    /// Current popularity.
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
    /// Has video.
    ///
    public let hasVideo: Bool?

    ///
    /// Is the movie only suitable for adults.
    ///
    public let isAdultOnly: Bool?

    ///
    /// Creates a movie object.
    ///
    /// - Parameters:
    ///    - id: Movie identifier.
    ///    - title: Movie title.
    ///    - tagline: Movie tagline.
    ///    - originalTitle: Original movie title.
    ///    - originalLanguage: Original language of the movie.
    ///    - overview: Movie overview.
    ///    - runtime: Movie runtime, in minutes.
    ///    - genres: Movie genres.
    ///    - releaseDate: Movie release date.
    ///    - posterPath: Movie poster path.
    ///    - backdropPath: Movie poster backdrop path.
    ///    - budget: Movie budget, in US dollars.
    ///    - revenue: Movie revenue, in US dollars.
    ///    - homepageURL: Movie's web site URL.
    ///    - imdbID: IMDd identifier.
    ///    - status: Movie status.
    ///    - productionCompanies: Movie production companies.
    ///    - productionCountries: Movie production countries.
    ///    - spokenLanguages: Movie spoken languages.
    ///    - popularity: Current popularity.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    ///    - hasVideo: Has video.
    ///    - isAdultOnly: Is the movie only suitable for adults.
    ///
    public init(
        id: Int,
        title: String,
        tagline: String? = nil,
        originalTitle: String? = nil,
        originalLanguage: String? = nil,
        overview: String? = nil,
        runtime: Int? = nil,
        genres: [Int]? = nil,
        releaseDate: Date? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        budget: Double? = nil,
        revenue: Double? = nil,
        homepageURL: URL? = nil,
        imdbID: String? = nil,
        status: Status? = nil,
        productionCompanies: [ProductionCompany]? = nil,
        productionCountries: [ProductionCountry]? = nil,
        spokenLanguages: [SpokenLanguage]? = nil,
        popularity: Double? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        hasVideo: Bool? = nil,
        isAdultOnly: Bool? = nil
    ) {
        self.id = id
        self.title = title
        self.tagline = tagline
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.runtime = runtime
        self.genreIds = genres
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.budget = budget
        self.revenue = revenue
        self.homepageURL = homepageURL
        self.imdbID = imdbID
        self.status = status
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.spokenLanguages = spokenLanguages
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.hasVideo = hasVideo
        self.isAdultOnly = isAdultOnly
    }

}

extension Movie {

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case tagline
        case originalTitle
        case originalLanguage
        case overview
        case runtime
        case genreIds
        case releaseDate
        case posterPath
        case backdropPath
        case budget
        case revenue
        case homepageURL = "homepage"
        case imdbID = "imdbId"
        case status
        case productionCompanies
        case productionCountries
        case spokenLanguages
        case popularity
        case voteAverage
        case voteCount
        case hasVideo = "video"
        case isAdultOnly = "adult"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let container2 = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        self.genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds)

        // Need to deal with empty strings - date decoding will fail with an empty string
        let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.releaseDate = try {
            guard let releaseDateString, !releaseDateString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(Date.self, forKey: .releaseDate)
        }()

        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(URL.self, forKey: .backdropPath)
        self.budget = try container.decodeIfPresent(Double.self, forKey: .budget)
        self.revenue = try container.decodeIfPresent(Double.self, forKey: .revenue)

        // Need to deal with empty strings - URL decoding will fail with an empty string
        let homepageURLString = try container.decodeIfPresent(String.self, forKey: .homepageURL)
        self.homepageURL = try {
            guard let homepageURLString, !homepageURLString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(URL.self, forKey: .homepageURL)
        }()

        self.imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)
        self.status = try container.decodeIfPresent(Status.self, forKey: .status)
        self.productionCompanies = try container.decodeIfPresent([ProductionCompany].self, forKey: .productionCompanies)
        self.productionCountries = try container.decodeIfPresent([ProductionCountry].self, forKey: .productionCountries)
        self.spokenLanguages = try container.decodeIfPresent([SpokenLanguage].self, forKey: .spokenLanguages)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.hasVideo = try container.decodeIfPresent(Bool.self, forKey: .hasVideo)
        self.isAdultOnly = try container.decodeIfPresent(Bool.self, forKey: .isAdultOnly)
    }

}
