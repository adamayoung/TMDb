import Foundation

///
/// A model representing a TV season.
///
public struct TVSeason: Identifiable, Codable, Equatable, Hashable {

    ///
    /// TV season identifier.
    ///
    public let id: Int

    ///
    /// TV season name.
    ///
    public let name: String

    ///
    /// TV season number.
    ///
    public let seasonNumber: Int

    ///
    /// Overview of TV season.
    ///
    public let overview: String?

    ///
    /// TV season's air date.
    ///
    public let airDate: Date?

    ///
    /// TV season's poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// Episodes in this TV season.
    ///
    public let episodes: [TVEpisode]?

    ///
    /// Creates a TV season object.
    ///
    /// - Parameters:
    ///    - id: TV season identifier.
    ///    - name: TV season name.
    ///    - seasonNumber: TV season number.
    ///    - overview: Overview of TV season.
    ///    - airDate: TV season's air date.
    ///    - posterPath: TV season's poster path.
    ///    - episodes: Episodes in this TV season.
    ///
    public init(
        id: Int,
        name: String,
        seasonNumber: Int,
        overview: String? = nil,
        airDate: Date? = nil,
        posterPath: URL? = nil,
        episodes: [TVEpisode]? = nil
    ) {
        self.id = id
        self.name = name
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.airDate = airDate
        self.posterPath = posterPath
        self.episodes = episodes
    }

}
