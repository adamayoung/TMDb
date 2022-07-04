import Foundation

/// A service to fetch credits for a person.
public protocol PersonCreditsService {

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

}
