import Foundation

public struct Movie: Identifiable, Decodable, Equatable, PosterURLProviding, BackdropURLProviding {

    public let id: Int
    public let title: String
    public let tagline: String?
    public let originalTitle: String?
    public let originalLanguage: String?
    public let overview: String?
    public let runtime: Int?
    public let genres: [Genre]?
    public let posterPath: URL?
    public let backdropPath: URL?
    public let budget: Float?
    public let revenue: Double?
    public let imdbID: String?
    public let status: Status?
    public let productionCompanies: [ProductionCompany]?
    public let productionCountries: [ProductionCountry]?
    public let spokenLanguages: [SpokenLanguage]?
    public let popularity: Float?
    public let voteAverage: Float?
    public let voteCount: Int?
    public let video: Bool?
    public let adult: Bool?

    private let releaseDateString: String?
    private let homepage: String?

    public init(id: Int, title: String, tagline: String? = nil, originalTitle: String? = nil,
                originalLanguage: String? = nil, overview: String? = nil, runtime: Int? = nil,
                genres: [Genre]? = nil, releaseDate: Date? = nil, posterPath: URL? = nil, backdropPath: URL? = nil,
                budget: Float? = nil, revenue: Double? = nil, homepageURL: URL? = nil, imdbID: String? = nil,
                status: Status? = nil, productionCompanies: [ProductionCompany]? = nil,
                productionCountries: [ProductionCountry]? = nil, spokenLanguages: [SpokenLanguage]? = nil,
                popularity: Float? = nil, voteAverage: Float? = nil, voteCount: Int? = nil, video: Bool? = nil,
                adult: Bool? = nil) {
        self.id = id
        self.title = title
        self.tagline = tagline
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.runtime = runtime
        self.genres = genres
        self.releaseDateString = {
            guard let releaseDate = releaseDate else {
                return nil
            }

            return DateFormatter.theMovieDatabase.string(from: releaseDate)
        }()
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.budget = budget
        self.revenue = revenue
        self.homepage = homepageURL?.absoluteString
        self.imdbID = imdbID
        self.status = status
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.spokenLanguages = spokenLanguages
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.video = video
        self.adult = adult
    }

}

extension Movie {

    public var releaseDate: Date? {
        guard let releaseDateString = releaseDateString else {
            return nil
        }

        return DateFormatter.theMovieDatabase.date(from: releaseDateString)
    }

    public var homepageURL: URL? {
        guard let homepage = homepage else {
            return nil
        }

        return URL(string: homepage)
    }

}

extension Movie: Comparable {

    public static func < (lhs: Movie, rhs: Movie) -> Bool {
        guard let lhsDate = lhs.releaseDate else {
            return false
        }

        guard let rhsDate = rhs.releaseDate else {
            return true
        }

        return lhsDate > rhsDate
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
        case genres
        case releaseDateString = "releaseDate"
        case posterPath
        case backdropPath
        case budget
        case revenue
        case imdbID = "imdbId"
        case status
        case homepage
        case productionCompanies
        case productionCountries
        case spokenLanguages
        case popularity
        case voteAverage
        case voteCount
        case video
        case adult
    }

}
