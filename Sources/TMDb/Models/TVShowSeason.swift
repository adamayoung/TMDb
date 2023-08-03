import Foundation

///
/// A model representing a TV show season.
///
public struct TVShowSeason: Identifiable, Codable, Equatable, Hashable {

    ///
    /// TV show season identifier.
    ///
    public let id: Int

    ///
    /// TV show season name.
    ///
    public let name: String

    ///
    /// TV show season number.
    ///
    public let seasonNumber: Int

    ///
    /// Overview of TV show season.
    ///
    public let overview: String?

    ///
    /// TV show season's air date.
    ///
    public let airDate: Date?

    ///
    /// TV show season's poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// Episode's in this TV show season.
    ///
    public let episodes: [TVShowEpisode]?

    ///
    /// Creates a TV show season object.
    ///
    /// - Parameters:
    ///    - id: TV show season identifier.
    ///    - name: TV show season name.
    ///    - seasonNumber: TV show season number.
    ///    - overview: Overview of TV show season.
    ///    - airDate: TV show season's air date.
    ///    - posterPath: TV show season's poster path.
    ///    - episodes: Episode's in this TV show season.
    ///
    public init(
        id: Int,
        name: String,
        seasonNumber: Int,
        overview: String? = nil,
        airDate: Date? = nil,
        posterPath: URL? = nil,
        episodes: [TVShowEpisode]? = nil
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
