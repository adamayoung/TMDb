import Foundation

/// Fetch details about people.
public protocol PersonService {

    /// Returns the primary information about a person.
    ///
    /// [TMDb API - People: Details](https://developers.themoviedb.org/3/people/get-person-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: The matching person.
    func details(forPerson id: Person.ID) async throws -> Person
    /// Returns the combined movie and TV show credits of a person.
    ///
    /// [TMDb API - People: Combined Credits](https://developers.themoviedb.org/3/people/get-person-combined-credits)
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's combined movie and TV show credits..
    func combinedCredits(forPerson personID: Person.ID) async throws -> PersonCombinedCredits

    /// Returns the movie credits of a person.
    ///
    /// [TMDb API - People: Movie Credits](https://developers.themoviedb.org/3/people/get-person-movie-credits)
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's movie credits.
    func movieCredits(forPerson personID: Person.ID) async throws -> PersonMovieCredits
    /// Returns the TV show credits of a person.
    ///
    /// [TMDb API - People: TV Show Credits](https://developers.themoviedb.org/3/people/get-person-tv-credits)
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's TV show credits.
    func tvShowCredits(forPerson personID: Person.ID) async throws -> PersonTVShowCredits

    /// Returns the images for a person.
    ///
    /// [TMDb API - People: Images](https://developers.themoviedb.org/3/people/get-person-images)
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's images.
    func images(forPerson personID: Person.ID) async throws -> PersonImageCollection

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

public extension PersonService {

    func popular(page: Int? = nil) async throws -> PersonPageableList {
        try await popular(page: page)
    }

}
