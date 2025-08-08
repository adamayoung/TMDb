public struct TVSeasonBasic: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let id: Int
    public let airDate: String?
    public let episodeCount: Int?
    public let name, overview, posterPath: String?
    public let seasonNumber: Int
    public let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.seasonNumber = try container.decodeIfPresent(Int.self, forKey: .seasonNumber) ?? 0
        self.airDate = try container.decodeIfPresent(String.self, forKey: .airDate)
        self.episodeCount = try container.decodeIfPresent(Int.self, forKey: .episodeCount)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
    }

}
