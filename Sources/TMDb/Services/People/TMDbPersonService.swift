import Combine
import Foundation

public final class TMDbPersonService: PersonService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    public func fetchDetails(forPerson id: Person.ID) -> AnyPublisher<Person, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.details(personID: id))
    }

    public func fetchCombinedCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonCombinedCredits, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.combinedCredits(personID: personID))
    }

    public func fetchMovieCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonMovieCredits, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.movieCredits(personID: personID))
    }

    public func fetchTVCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonTVShowCredits, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.tvShowCredits(personID: personID))
    }

    public func fetchImages(forPerson personID: Person.ID) -> AnyPublisher<PersonImageCollection, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.images(personID: personID))
    }

    public func fetchPopular(page: Int?) -> AnyPublisher<PersonPageableListResult, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.popular(page: page))
    }

}
