import Combine
@testable import TMDb
import XCTest

final class MockPersonService: PersonService {

    var personDetails: PersonDTO?
    private(set) var lastPersonDetailsID: PersonDTO.ID?
    var combinedCredits: PersonCombinedCreditsDTO?
    private(set) var lastCombinedCredtsPersonID: PersonDTO.ID?
    var movieCredits: PersonMovieCreditsDTO?
    private(set) var lastMovieCreditsPersonID: PersonDTO.ID?
    var tvShowCredits: PersonTVShowCreditsDTO?
    private(set) var lastTVShowCreditsPersonID: PersonDTO.ID?
    var images: PersonImageCollectionDTO?
    private(set) var lastImagesPersonID: PersonDTO.ID?
    var knownFor: [ShowDTO]?
    private(set) var lastKnownForPersonID: PersonDTO.ID?
    var popular: PersonPageableListDTO?
    var lastPopularPage: Int?

    func fetchDetails(forPerson id: PersonDTO.ID) -> AnyPublisher<PersonDTO, TMDbError> {
        lastPersonDetailsID = id

        guard let personDetails = personDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(personDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchCombinedCredits(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonCombinedCreditsDTO, TMDbError> {
        lastCombinedCredtsPersonID = personID

        guard let combinedCredits = combinedCredits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(combinedCredits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchMovieCredits(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonMovieCreditsDTO, TMDbError> {
        lastMovieCreditsPersonID = personID

        guard let movieCredits = movieCredits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movieCredits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchTVShowCredits(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonTVShowCreditsDTO, TMDbError> {
        lastTVShowCreditsPersonID = personID

        guard let tvShowCredits = tvShowCredits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShowCredits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchImages(forPerson personID: PersonDTO.ID) -> AnyPublisher<PersonImageCollectionDTO, TMDbError> {
        lastImagesPersonID = personID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchKnownFor(forPerson personID: PersonDTO.ID) -> AnyPublisher<[ShowDTO], TMDbError> {
        lastKnownForPersonID = personID

        guard let knownFor = knownFor else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(knownFor)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchPopular(page: Int?) -> AnyPublisher<PersonPageableListDTO, TMDbError> {
        lastPopularPage = page

        guard let popular = popular else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(popular)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
