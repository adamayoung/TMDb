import Foundation

///
/// A model representing a TV show credits for a person.
///
/// A person can be both a cast member and crew member of the same TV show.
///
public struct PersonTVShowCredits: Identifiable, Decodable, Equatable, Hashable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// TV shows where the person is in the cast.
    ///
    public let cast: [TVShow]

    ///
    /// TV shows where the person is in the crew.
    ///
    public let crew: [TVShow]

    ///
    /// All TV shows the person is in.
    ///
    public var allShows: [TVShow] {
        (cast + crew).uniqued()
    }

    /// Creates a person TV show credits object.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - cast: TV shows where the person is in the cast.
    ///    - crew: TV shows where the person is in the crew.
    ///
    public init(id: Int, cast: [TVShow], crew: [TVShow]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
