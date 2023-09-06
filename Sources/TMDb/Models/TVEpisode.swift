import Foundation

///
/// A model representing a TV episode.
///
public struct TVEpisode: Identifiable, Codable, Equatable, Hashable {

    ///
    /// TV episode identifier.
    ///
    public let id: Int

    ///
    /// TV episode name.
    ///
    public let name: String

    ///
    /// TV episode number.
    ///
    public let episodeNumber: Int

    ///
    /// TV episode season number.
    ///
    public let seasonNumber: Int

    ///
    /// TV episode overview.
    ///
    public let overview: String?

    ///
    /// TV episode air date.
    ///
    public let airDate: Date?

    ///
    /// TV episode production code.
    ///
    public let productionCode: String?

    ///
    /// TV episode still image path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let stillPath: URL?

    ///
    /// TV episode crew.
    ///
    public let crew: [CrewMember]?

    ///
    /// TV episode guest cast members.
    ///
    public let guestStars: [CastMember]?

    ///
    /// Average vote score.
    ///
    public let voteAverage: Double?

    ///
    /// Number of votes.
    ///
    public let voteCount: Int?

    ///
    /// Creates a TV episode object.
    ///
    /// - Parameters:
    ///    - id: TV episode identifier.
    ///    - name: TV episode name.
    ///    - episodeNumber: TV episode number.
    ///    - seasonNumber: TV episode season number.
    ///    - overview: TV episode overview.
    ///    - airDate: TV episode air date.
    ///    - productionCode: TV episode production code.
    ///    - stillPath: TV episode still image path.
    ///    - crew: TV episode crew.
    ///    - guestStars: TV episode guest cast members.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    ///
    public init(
        id: Int,
        name: String,
        episodeNumber: Int,
        seasonNumber: Int,
        overview: String? = nil,
        airDate: Date? = nil,
        productionCode: String? = nil,
        stillPath: URL? = nil,
        crew: [CrewMember]? = nil,
        guestStars: [CastMember]? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil
    ) {
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
