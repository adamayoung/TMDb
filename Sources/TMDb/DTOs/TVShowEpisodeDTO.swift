import Foundation

public struct TVShowEpisodeDTO: Identifiable, Decodable, Equatable, StillURLProviding {

    public let id: Int
    public let name: String
    public let episodeNumber: Int
    public let seasonNumber: Int
    public let overview: String?
    public let airDate: Date?
    public let productionCode: String?
    public let stillPath: URL?
    public let crew: [CrewMemberDTO]?
    public let guestStars: [CastMemberDTO]?
    public let voteAverage: Float?
    public let voteCount: Int?

    public init(id: Int, name: String, episodeNumber: Int, seasonNumber: Int, overview: String? = nil,
                airDate: Date? = nil, productionCode: String? = nil, stillPath: URL? = nil,
                crew: [CrewMemberDTO]? = nil, guestStars: [CastMemberDTO]? = nil, voteAverage: Float? = nil,
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
