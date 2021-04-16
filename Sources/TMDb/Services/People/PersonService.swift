import Foundation

#if canImport(Combine)
import Combine
#endif

public protocol PersonService {

    /// Fetches the primary information about a person.
    ///
    /// - Note: [TMDb API - People: Details](https://developers.themoviedb.org/3/people/get-person-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///     - completion: Completion handler.
    ///     - result: The matching person.
    func fetchDetails(forPerson id: Person.ID, completion: @escaping (_ result: Result<Person, TMDbError>) -> Void)

    /// Fetches the combined movie and TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: Combined Credits](https://developers.themoviedb.org/3/people/get-person-combined-credits)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///     - completion: Completion handler.
    ///     - result: The matching person's combined movie and TV show credits..
    func fetchCombinedCredits(forPerson personID: Person.ID,
                              completion: @escaping (_ result: Result<PersonCombinedCredits, TMDbError>) -> Void)

    /// Fetches the movie credits of a person.
    ///
    /// - Note: [TMDb API - People: Movie Credits](https://developers.themoviedb.org/3/people/get-person-movie-credits)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///     - completion: Completion handler.
    ///     - result: The matching person's movie credits.
    func fetchMovieCredits(forPerson personID: Person.ID,
                           completion: @escaping (_ result: Result<PersonMovieCredits, TMDbError>) -> Void)

    /// Fetches the TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: TV Show Credits](https://developers.themoviedb.org/3/people/get-person-tv-credits)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///     - completion: Completion handler.
    ///     - result: The matching person's TV show credits.
    func fetchTVShowCredits(forPerson personID: Person.ID,
                            completion: @escaping (_ result: Result<PersonTVShowCredits, TMDbError>) -> Void)

    /// Fetches the images for a person.
    ///
    /// - Note: [TMDb API - People: Images](https://developers.themoviedb.org/3/people/get-person-images)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///     - completion: Completion handler.
    ///     - result: The matching person's images.
    func fetchImages(forPerson personID: Person.ID,
                     completion: @escaping (_ result: Result<PersonImageCollection, TMDbError>) -> Void)

    /// Fetches the list of known for shows for a person.
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///     - completion: Completion handler.
    ///     - result: The matching person's show credits.
    func fetchKnownFor(forPerson personID: Person.ID,
                       completion: @escaping (_ result: Result<[Show], TMDbError>) -> Void)

    /// Fetches the list of popular people.
    ///
    /// - Note: [TMDb API - People: Popular](https://developers.themoviedb.org/3/people/get-popular-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Current popular people as a pageable list.
    func fetchPopular(page: Int?, completion: @escaping (_ result: Result<PersonPageableList, TMDbError>) -> Void)

    #if canImport(Combine)
    /// Publishes the primary information about a person.
    ///
    /// - Note: [TMDb API - People: Details](https://developers.themoviedb.org/3/people/get-person-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func detailsPublisher(forPerson id: Person.ID) -> AnyPublisher<Person, TMDbError>

    /// Publishes the combined movie and TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: Combined Credits](https://developers.themoviedb.org/3/people/get-person-combined-credits)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person's combined movie and TV show credits.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func combinedCreditsPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonCombinedCredits, TMDbError>

    /// Publishes the movie credits of a person.
    ///
    /// - Note: [TMDb API - People: Movie Credits](https://developers.themoviedb.org/3/people/get-person-movie-credits)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person's movie credits.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func movieCreditsPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonMovieCredits, TMDbError>

    /// Publishes the TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: TV Show Credits](https://developers.themoviedb.org/3/people/get-person-tv-credits)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person's TV show credits.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowCreditsPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonTVShowCredits, TMDbError>

    /// Publishes the images for a person.
    ///
    /// - Note: [TMDb API - People: Images](https://developers.themoviedb.org/3/people/get-person-images)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person's images.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func imagesPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonImageCollection, TMDbError>

    /// Publishes the list of known for shows for a person.
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: A publisher with the matching person's show credits.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func popularPublisher(page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>
    #endif

}

public extension PersonService {

    func fetchPopular(page: Int? = nil,
                      completion: @escaping (_ result: Result<PersonPageableList, TMDbError>) -> Void) {
        fetchPopular(page: page, completion: completion)
    }

}

#if canImport(Combine)
public extension PersonService {

    func popularPublisher(page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        popularPublisher(page: page)
    }

}
#endif
