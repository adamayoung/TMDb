import Foundation

public struct TVShow: Identifiable, Decodable {

    public let id: Int
    public let name: String
    public let originalName: String
    public let originalLanguage: String?
    public let overview: String?
    public let episodeRuntime: [Int]?
    public let numberOfSeasons: Int?
    public let numberOfEpisodes: Int?
    public let seasons: [Season]?
    public let genres: [Genre]?
    public let originCountry: [String]?
    public let posterPath: URL?
    public let backdropPath: URL?
    public let inProduction: Bool?
    public let languages: [String]?
    public let lastAirDate: Date?
    public let lastEpisodeToAir: Episode?
    public let networks: [Network]?
    public let productionCompanies: [ProductionCompany]?
    public let status: String?
    public let type: String?
    public let popularity: Float?
    public let voteAverage: Float?
    public let voteCount: Int?

    private let firstAirDateString: String?
    private let homepage: String?

    public init(id: Int, name: String, originalName: String, originalLanguage: String? = nil, overview: String? = nil,
                episodeRuntime: [Int]? = nil, numberOfSeasons: Int? = nil, numberOfEpisodes: Int? = nil,
                seasons: [TVShow.Season]? = nil, genres: [Genre]? = nil, firstAirDate: Date? = nil,
                originCountry: [String]? = nil, posterPath: URL? = nil, backdropPath: URL? = nil,
                homepageURL: URL? = nil, inProduction: Bool? = nil, languages: [String]? = nil,
                lastAirDate: Date? = nil, lastEpisodeToAir: TVShow.Episode? = nil, networks: [TVShow.Network]? = nil,
                productionCompanies: [ProductionCompany]? = nil, status: String? = nil, type: String? = nil,
                popularity: Float? = nil, voteAverage: Float? = nil, voteCount: Int? = nil) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.episodeRuntime = episodeRuntime
        self.numberOfSeasons = numberOfSeasons
        self.numberOfEpisodes = numberOfEpisodes
        self.seasons = seasons
        self.genres = genres
        self.firstAirDateString = {
            guard let firstAirDate = firstAirDate else {
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
        self.lastEpisodeToAir = lastEpisodeToAir
        self.networks = networks
        self.productionCompanies = productionCompanies
        self.status = status
        self.type = type
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

}

extension TVShow {

    public var firstAirDate: Date? {
        guard let firstAirDateString = firstAirDateString else {
            return nil
        }

        return DateFormatter.theMovieDatabase.date(from: firstAirDateString)
    }

    public var homepageURL: URL? {
        guard let homepage = homepage else {
            return nil
        }

        return URL(string: homepage)
    }

}

extension TVShow {

    public struct Episode: Identifiable, Decodable {

        public let id: Int
        public let name: String
        public let overview: String
        public let seasonNumber: Int
        public let episodeNumber: Int
        public let airDate: Date
        public let productionCode: String
        public let showId: Int
        public let stillPath: URL?
        public let voteAverage: Float
        public let voteCount: Int

        public init(id: Int, name: String, overview: String, seasonNumber: Int, episodeNumber: Int, airDate: Date,
                    productionCode: String, showId: Int, stillPath: URL? = nil, voteAverage: Float, voteCount: Int) {
            self.id = id
            self.name = name
            self.overview = overview
            self.seasonNumber = seasonNumber
            self.episodeNumber = episodeNumber
            self.airDate = airDate
            self.productionCode = productionCode
            self.showId = showId
            self.stillPath = stillPath
            self.voteAverage = voteAverage
            self.voteCount = voteCount
        }

    }

}

extension TVShow {

    public class Season: Identifiable, Decodable {

        public let id: Int
        public let name: String
        public let overview: String?
        public let seasonNumber: Int
        public let episodeCount: Int
        public let airDate: Date?
        public let posterPath: URL?

        public init(id: Int, name: String, overview: String? = nil, seasonNumber: Int, episodeCount: Int,
                    airDate: Date? = nil, posterPath: URL? = nil) {
            self.id = id
            self.name = name
            self.overview = overview
            self.seasonNumber = seasonNumber
            self.episodeCount = episodeCount
            self.airDate = airDate
            self.posterPath = posterPath
        }

    }

}

extension TVShow {

    public struct Network: Identifiable, Decodable {

        public let id: Int
        public let name: String
        public let logoPath: URL?
        public let originCountry: String

        public init(id: Int, name: String, logoPath: URL? = nil, originCountry: String) {
            self.id = id
            self.name = name
            self.logoPath = logoPath
            self.originCountry = originCountry
        }

    }

}

extension TVShow {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName
        case originalLanguage
        case overview
        case episodeRuntime
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
        case lastEpisodeToAir
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
