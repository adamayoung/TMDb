import Foundation

/// A service to fetch details of a person.
public protocol PersonDetailsService {

    /// Returns the primary information about a person.
    ///
    /// [TMDb API - People: Details](https://developers.themoviedb.org/3/people/get-person-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: The matching person.
    func details(forPerson id: Person.ID) async throws -> Person

}
