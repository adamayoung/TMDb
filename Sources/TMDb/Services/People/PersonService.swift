import Combine
import Foundation

protocol PersonService {

    func fetchDetails(forPerson id: PersonDTO.ID) -> AnyPublisher<PersonDTO, TMDbError>

    func fetchCombinedCredits(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonCombinedCreditsDTO, TMDbError>

    func fetchMovieCredits(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonMovieCreditsDTO, TMDbError>

    func fetchTVShowCredits(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonTVShowCreditsDTO, TMDbError>

    func fetchImages(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonImageCollectionDTO, TMDbError>

    func fetchKnownFor(forPerson personID: PersonDTO.ID) -> AnyPublisher<[ShowDTO], TMDbError>

    func fetchPopular(page: Int?) -> AnyPublisher<PersonPageableListDTO, TMDbError>

}
