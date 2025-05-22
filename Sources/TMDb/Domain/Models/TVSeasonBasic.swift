public struct TVSeasonBasic: Codable {
    public let id: Int
    public let airDate: String?
    public let episodeCount: Int?
    public let name, overview, posterPath: String?
    public let seasonNumber: Int?
    public let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case voteAverage = "vote_average"
    }
}
