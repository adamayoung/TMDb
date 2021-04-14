import Combine
import Foundation

public protocol PersonAPI {

    /// Publishes the primary information about a person.
    ///
    /// - Note: [TMDb API - People: Details](https://developers.themoviedb.org/3/people/get-person-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person.
    func detailsPublisher(forPerson id: Person.ID) -> AnyPublisher<Person, TMDbError>

    /// Publishes the combined movie and TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: Combined Credits](https://developers.themoviedb.org/3/people/get-person-combined-credits)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person's combined movie and TV show credits.
    func combinedCreditsPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonCombinedCredits, TMDbError>

    /// Publishes the movie credits of a person.
    ///
    /// - Note: [TMDb API - People: Movie Credits](https://developers.themoviedb.org/3/people/get-person-movie-credits)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person's movie credits.
    func movieCreditsPublisher(
        forPerson personID: Person.ID) -> AnyPublisher<PersonMovieCredits, TMDbError>

    /// Publishes the TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: TV Show Credits](https://developers.themoviedb.org/3/people/get-person-tv-credits)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person's TV show credits.
    func tvShowCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonTVShowCredits, TMDbError>

    /// Publishes the images for a person.
    ///
    /// - Note: [TMDb API - People: Images](https://developers.themoviedb.org/3/people/get-person-images)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person's images.
    func imagesPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonImageCollection, TMDbError>

    /// Publishes the list of known for shows for a person.
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person's show credits.
    func knownForPublisher(forPerson personID: Person.ID) -> AnyPublisher<[Show], TMDbError>

    /// Publishes the list of popular people.
    ///
    /// - Note: [TMDb API - People: Popular](https://developers.themoviedb.org/3/people/get-popular-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher of current popular people as a pageable list.
    func popularPeoplePublisher(page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>

}

public extension PersonAPI {

    func popularPeoplePublisher(page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        popularPeoplePublisher(page: page)
    }

}
