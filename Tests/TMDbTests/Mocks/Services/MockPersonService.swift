@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

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

    func fetchDetails(forPerson id: Person.ID, completion: @escaping (Result<Person, TMDbError>) -> Void) {
        lastPersonDetailsID = id

        guard let personDetails = personDetails else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(personDetails))
        }
    }

    func fetchCombinedCredits(forPerson personID: Person.ID,
                              completion: @escaping (Result<PersonCombinedCredits, TMDbError>) -> Void) {
        lastCombinedCredtsPersonID = personID

        guard let combinedCredits = combinedCredits else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(combinedCredits))
        }
    }

    func fetchMovieCredits(forPerson personID: Person.ID,
                           completion: @escaping (Result<PersonMovieCredits, TMDbError>) -> Void) {
        lastMovieCreditsPersonID = personID

        guard let movieCredits = movieCredits else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(movieCredits))
        }
    }

    func fetchTVShowCredits(forPerson personID: Person.ID,
                            completion: @escaping (Result<PersonTVShowCredits, TMDbError>) -> Void) {
        lastTVShowCreditsPersonID = personID

        guard let tvShowCredits = tvShowCredits else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(tvShowCredits))
        }
    }

    func fetchImages(forPerson personID: Person.ID,
                     completion: @escaping (Result<PersonImageCollection, TMDbError>) -> Void) {
        lastImagesPersonID = personID

        guard let images = images else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(images))
        }
    }

    func fetchKnownFor(forPerson personID: Person.ID, completion: @escaping (Result<[Show], TMDbError>) -> Void) {
        lastKnownForPersonID = personID

        guard let knownFor = knownFor else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(knownFor))
        }
    }

    func fetchPopular(page: Int?, completion: @escaping (Result<PersonPageableList, TMDbError>) -> Void) {
        lastPopularPage = page

        guard let popular = popular else {
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(popular))
        }
    }

}

#if canImport(Combine)
extension MockPersonService {

    func detailsPublisher(forPerson id: Person.ID) -> AnyPublisher<Person, TMDbError> {
        lastPersonDetailsID = id

        guard let personDetails = personDetails else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(personDetails)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func combinedCreditsPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonCombinedCredits, TMDbError> {
        lastCombinedCredtsPersonID = personID

        guard let combinedCredits = combinedCredits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(combinedCredits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func movieCreditsPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonMovieCredits, TMDbError> {
        lastMovieCreditsPersonID = personID

        guard let movieCredits = movieCredits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(movieCredits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func tvShowCreditsPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonTVShowCredits, TMDbError> {
        lastTVShowCreditsPersonID = personID

        guard let tvShowCredits = tvShowCredits else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(tvShowCredits)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func imagesPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonImageCollection, TMDbError> {
        lastImagesPersonID = personID

        guard let images = images else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(images)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func knownForPublisher(forPerson personID: Person.ID) -> AnyPublisher<[Show], TMDbError> {
        lastKnownForPersonID = personID

        guard let knownFor = knownFor else {
            return Empty()
                .eraseToAnyPublisher()
        }

        return Just(knownFor)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func popularPublisher(page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
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
#endif
