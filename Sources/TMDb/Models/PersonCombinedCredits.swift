import Foundation

/// Combined movie and tv show credits for a person.
///
/// A person can be both a cast member and crew member of the same show.
public struct PersonCombinedCredits: Identifiable, Decodable, Equatable {

    /// Person identifier.
    public let id: Int
    /// Shows where the person is in the cast.
    public let cast: [Show]
    /// Shows where the person is in the case.
    public let crew: [Show]

    /// Create a new `PersonCombinedCredits`.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - cast: Shows where person is in the cast.
    ///    - crew: Shows where person is in the case.
    public init(id: Int, cast: [Show], crew: [Show]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
