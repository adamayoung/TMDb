import Combine
import Foundation

public protocol PersonService {

    func fetchDetails(forPerson id: Person.ID) -> AnyPublisher<Person, TMDbError>

    func fetchCombinedCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonCombinedCredits, TMDbError>

    func fetchMovieCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonMovieCredits, TMDbError>

    func fetchTVCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonTVShowCredits, TMDbError>

    func fetchImages(forPerson personID: Person.ID) -> AnyPublisher<PersonImageCollection, TMDbError>

    func fetchPopular(page: Int?) -> AnyPublisher<PersonPageableListResult, TMDbError>

}

extension PersonService {

    public func fetchPopular(page: Int? = nil) -> AnyPublisher<PersonPageableListResult, TMDbError> {
        fetchPopular(page: page)
    }

}
