import Foundation

///
/// A model representing movie credits for a person.
///
/// A person can be both a cast member and crew member of the same movie.
///
public struct PersonMovieCredits: Identifiable, Decodable, Equatable, Hashable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// Movies where the person is in the cast.
    ///
    public let cast: [Movie]

    ///
    /// Movies where the person is in the crew.
    ///
    public let crew: [Movie]

    ///
    /// All movies the person is in.
    ///
    public var allShows: [Movie] {
        (cast + crew).uniqued()
    }

    /// Creates a person movie credits object.
    ///
    /// - Parameters:
    ///   - id: Person identifier
    ///   - cast: Movies where the person is in the cast.
    ///   - crew: Movies where the person is in the crew.
    ///
    public init(id: Int, cast: [Movie], crew: [Movie]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
