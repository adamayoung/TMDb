import Foundation

/// Movie credits for a person.
///
/// A person can be both a cast member and crew member of the same movie.
public struct PersonMovieCredits: Identifiable, Decodable, Equatable {

    /// Person identifier.
    public let id: Int
    /// Movies where the person is in the cast.
    public let cast: [Movie]
    /// Movies where the person is in the crew.
    public let crew: [Movie]

    /// Creates a new `PersonMovieCredits`.
    public init(id: Int, cast: [Movie], crew: [Movie]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
