import Combine
@testable import TMDb
import XCTest

final class MockPersonService: PersonService {

    var personDetails: Person?
    private(set) var lastPersonDetailsID: Person.ID?
    var combinedCredits: PersonCombinedCredits?
    private(set) var lastCombinedCredtsPersonID: Person.ID?
    var movieCredits: PersonMovieCredits?
    private(set) var lastMovieCreditsPersonID: Person.ID?
    var tvShowCredits: PersonTVShowCredits?
    private(set) var lastTVShowCreditsPersonID: Person.ID?
    var images: PersonImageCollection?
    private(set) var lastImagesPersonID: Person.ID?
    var knownFor: [Show]?
    private(set) var lastKnownForPersonID: Person.ID?
    var popular: PersonPageableList?
    var lastPopularPage: Int?

    func fetchDetails(forPerson id: Person.ID) -> AnyPublisher<Person, TMDbError> {
        lastPersonDetailsID = id

        guard let personDetails = personDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(personDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchCombinedCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonCombinedCredits, TMDbError> {
        lastCombinedCredtsPersonID = personID

        guard let combinedCredits = combinedCredits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(combinedCredits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchMovieCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonMovieCredits, TMDbError> {
        lastMovieCreditsPersonID = personID

        guard let movieCredits = movieCredits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movieCredits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchTVShowCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonTVShowCredits, TMDbError> {
        lastTVShowCreditsPersonID = personID

        guard let tvShowCredits = tvShowCredits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShowCredits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchImages(forPerson personID: Person.ID) -> AnyPublisher<PersonImageCollection, TMDbError> {
        lastImagesPersonID = personID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchKnownFor(forPerson personID: Person.ID) -> AnyPublisher<[Show], TMDbError> {
        lastKnownForPersonID = personID

        guard let knownFor = knownFor else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(knownFor)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchPopular(page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
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
