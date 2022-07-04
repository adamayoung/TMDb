import Foundation

/// A service to fetch various curated lists of people.
public protocol PersonListsService {

    /// Returns the list of known for shows for a person.
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's show credits.
    func knownFor(forPerson personID: Person.ID) async throws -> [Show]

    /// Returns the list of popular people.
    ///
    /// [TMDb API - People: Popular](https://developers.themoviedb.org/3/people/get-popular-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular people as a pageable list.
    func popular(page: Int?) async throws -> PersonPageableList

}

public extension PersonListsService {

    func popular(page: Int? = nil) async throws -> PersonPageableList {
        try await popular(page: page)
    }

}
