import Foundation

/// A TV show episode.
public struct TVShowEpisode: Identifiable, Decodable, Equatable, StillURLProviding {

    /// TV show episode identifier.
    public let id: Int
    /// TV show episode name.
    public let name: String
    /// TV show episode number.
    public let episodeNumber: Int
    /// TV show episode season number.
    public let seasonNumber: Int
    /// TV show episode overview.
    public let overview: String?
    /// TV show episode air date.
    public let airDate: Date?
    /// TV show episode production code.
    public let productionCode: String?
    /// TV show episode still image path.
    public let stillPath: URL?
    /// TV show episode crew.
    public let crew: [CrewMember]?
    /// TV show episode guest cast members.
    public let guestStars: [CastMember]?
    /// Average vote score.
    public let voteAverage: Double?
    /// Number of votes.
    public let voteCount: Int?

    /// Creates a new `TVShowEpisode`.
    ///
    /// - Parameters:
    ///    - id: TV show episode identifier.
    ///    - name: TV show episode name.
    ///    - episodeNumber: TV show episode number.
    ///    - seasonNumber: TV show episode season number.
    ///    - overview: TV show episode overview.
    ///    - airDate: TV show episode air date.
    ///    - productionCode: TV show episode production code.
    ///    - stillPath: TV show episode still image path.
    ///    - crew: TV show episode crew.
    ///    - guestStars: TV show episode guest cast members.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    public init(id: Int, name: String, episodeNumber: Int, seasonNumber: Int, overview: String? = nil,
                airDate: Date? = nil, productionCode: String? = nil, stillPath: URL? = nil,
                crew: [CrewMember]? = nil, guestStars: [CastMember]? = nil, voteAverage: Double? = nil,
                voteCount: Int? = nil) {
        self.id = id
        self.name = name
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.airDate = airDate
        self.productionCode = productionCode
        self.stillPath = stillPath
        self.crew = crew
        self.guestStars = guestStars
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

}
