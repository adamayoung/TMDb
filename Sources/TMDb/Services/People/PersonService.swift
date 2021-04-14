import Combine
import Foundation

protocol PersonService {

    func fetchDetails(forPerson id: Person.ID) -> AnyPublisher<Person, TMDbError>

    func fetchCombinedCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonCombinedCredits, TMDbError>

    func fetchMovieCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonMovieCredits, TMDbError>

    func fetchTVShowCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonTVShowCredits, TMDbError>

    func fetchImages(forPerson personID: Person.ID) -> AnyPublisher<PersonImageCollection, TMDbError>

    func fetchKnownFor(forPerson personID: Person.ID) -> AnyPublisher<[Show], TMDbError>

    func fetchPopular(page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>

}
