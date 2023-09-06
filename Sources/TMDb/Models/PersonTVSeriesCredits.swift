import Foundation

///
/// A model representing a TV series credits for a person.
///
/// A person can be both a cast member and crew member of the same TV series.
///
public struct PersonTVSeriesCredits: Identifiable, Decodable, Equatable, Hashable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// TV series where the person is in the cast.
    ///
    public let cast: [TVSeries]

    ///
    /// TV series where the person is in the crew.
    ///
    public let crew: [TVSeries]

    ///
    /// All TV series the person is in.
    ///
    public var allShows: [TVSeries] {
        (cast + crew).uniqued()
    }

    ///
    /// Creates a person TV series credits object.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - cast: TV series where the person is in the cast.
    ///    - crew: TV series where the person is in the crew.
    ///
    public init(id: Int, cast: [TVSeries], crew: [TVSeries]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
