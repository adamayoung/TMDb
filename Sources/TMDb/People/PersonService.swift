import Foundation

///
/// Provides an interface for obtaining people from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class PersonService {

    private static let knownForShowsMaxCount = 10

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
        let person: Person
        do {
            person = try await apiClient.get(endpoint: PeopleEndpoint.details(personID: id))
        } catch let error {
            throw error
        }

        return person
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
        let credits: PersonCombinedCredits
        do {
            credits = try await apiClient.get(endpoint: PeopleEndpoint.combinedCredits(personID: personID))
        } catch let error {
            throw error
        }

        return credits
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
        let credits: PersonMovieCredits
        do {
            credits = try await apiClient.get(endpoint: PeopleEndpoint.movieCredits(personID: personID))
        } catch let error {
            throw error
        }

        return credits
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
        let credits: PersonTVShowCredits
        do {
            credits = try await apiClient.get(endpoint: PeopleEndpoint.tvShowCredits(personID: personID))
        } catch let error {
            throw error
        }

        return credits
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
        let imageCollection: PersonImageCollection
        do {
            imageCollection = try await apiClient.get(endpoint: PeopleEndpoint.images(personID: personID))
        } catch let error {
            throw error
        }

        return imageCollection
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
        let credits: PersonCombinedCredits
        do {
            credits = try await apiClient.get(endpoint: PeopleEndpoint.combinedCredits(personID: personID))
        } catch let error {
            throw error
        }

        let topShowsSubSequence = credits.allShows.lazy
            .sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }
            .prefix(Self.knownForShowsMaxCount)
        let shows = Array(topShowsSubSequence)

        return shows
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
        let personList: PersonPageableList
        do {
            personList = try await apiClient.get(endpoint: PeopleEndpoint.popular(page: page))
        } catch let error {
            throw error
        }

        return personList
    }

}
