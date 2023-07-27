import Foundation

///
/// Provides an interface for obtaining people from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class PersonService {

    private let apiClient: APIClient

    ///
    /// Creates a person service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns the primary information about a person.
    ///
    /// [TMDb API - People: Details](https://developers.themoviedb.org/3/people/get-person-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///
    /// - Returns: The matching person.
    /// 
    public func details(forPerson id: Person.ID) async throws -> Person {
        try await apiClient.get(endpoint: PeopleEndpoint.details(personID: id))
    }

    ///
    /// Returns the combined movie and TV show credits of a person.
    ///
    /// [TMDb API - People: Combined Credits](https://developers.themoviedb.org/3/people/get-person-combined-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's combined movie and TV show credits.
    /// 
    public func combinedCredits(forPerson personID: Person.ID) async throws -> PersonCombinedCredits {
        let endpoint = PeopleEndpoint.combinedCredits(personID: personID)
        let credits: PersonCombinedCredits = try await apiClient.get(endpoint: endpoint)
        let sortedCast = credits.cast.sorted()
        let sortedCrew = credits.crew.sorted()
        return PersonCombinedCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
    }

    ///
    /// Returns the movie credits of a person.
    ///
    /// [TMDb API - People: Movie Credits](https://developers.themoviedb.org/3/people/get-person-movie-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's movie credits.
    /// 
    public func movieCredits(forPerson personID: Person.ID) async throws -> PersonMovieCredits {
        let endpoint = PeopleEndpoint.movieCredits(personID: personID)
        let credits: PersonMovieCredits = try await apiClient.get(endpoint: endpoint)
        let sortedCast = credits.cast.sorted()
        let sortedCrew = credits.crew.sorted()
        return PersonMovieCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
    }

    ///
    /// Returns the TV show credits of a person.
    ///
    /// [TMDb API - People: TV Show Credits](https://developers.themoviedb.org/3/people/get-person-tv-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's TV show credits.
    /// 
    public func tvShowCredits(forPerson personID: Person.ID) async throws -> PersonTVShowCredits {
        let endpoint = PeopleEndpoint.tvShowCredits(personID: personID)
        let credits: PersonTVShowCredits = try await apiClient.get(endpoint: endpoint)
        let sortedCast = credits.cast.sorted()
        let sortedCrew = credits.crew.sorted()
        return PersonTVShowCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
    }

    ///
    /// Returns the images for a person.
    ///
    /// [TMDb API - People: Images](https://developers.themoviedb.org/3/people/get-person-images)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's images.
    ///
    public func images(forPerson personID: Person.ID) async throws -> PersonImageCollection {
        try await apiClient.get(endpoint: PeopleEndpoint.images(personID: personID))
    }

    ///
    /// Returns the list of known for shows for a person.
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's show credits.
    /// 
    public func knownFor(forPerson personID: Person.ID) async throws -> [Show] {
        let credits: PersonCombinedCredits = try await combinedCredits(forPerson: personID)
        return Self.knownForIn(credits: credits)
    }

    ///
    /// Returns the list of popular people.
    ///
    /// [TMDb API - People: Popular](https://developers.themoviedb.org/3/people/get-popular-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///
    /// - Returns: Current popular people as a pageable list.
    ///
    public func popular(page: Int? = nil) async throws -> PersonPageableList {
        try await apiClient.get(endpoint: PeopleEndpoint.popular(page: page))
    }

}

extension PersonService {

    private static func knownForIn(credits: PersonCombinedCredits) -> [Show] {
        let topShows = credits.allShows
            .sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }

        return Array(topShows.prefix(10))
    }

}
