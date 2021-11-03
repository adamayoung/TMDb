import Foundation

#if canImport(Combine)
import Combine
#endif

final class TMDbPersonService: PersonService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchDetails(forPerson id: Person.ID, completion: @escaping (Result<Person, TMDbError>) -> Void) {
        apiClient.get(endpoint: PeopleEndpoint.details(personID: id), completion: completion)
    }

    func fetchCombinedCredits(forPerson personID: Person.ID,
                              completion: @escaping (Result<PersonCombinedCredits, TMDbError>) -> Void) {
        let endpoint = PeopleEndpoint.combinedCredits(personID: personID)
        apiClient.get(endpoint: endpoint) { (result: Result<PersonCombinedCredits, TMDbError>) in
            completion(result.map { credits in
                let sortedCast = credits.cast.sorted()
                let sortedCrew = credits.crew.sorted()
                return PersonCombinedCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
            })
        }
    }

    func fetchMovieCredits(forPerson personID: Person.ID,
                           completion: @escaping (Result<PersonMovieCredits, TMDbError>) -> Void) {
        let endpoint = PeopleEndpoint.movieCredits(personID: personID)
        apiClient.get(endpoint: endpoint) { (result: Result<PersonMovieCredits, TMDbError>) in
            completion(result.map { credits in
                let sortedCast = credits.cast.sorted()
                let sortedCrew = credits.crew.sorted()
                return PersonMovieCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
            })
        }
    }

    func fetchTVShowCredits(forPerson personID: Person.ID,
                            completion: @escaping (Result<PersonTVShowCredits, TMDbError>) -> Void) {
        let endpoint = PeopleEndpoint.tvShowCredits(personID: personID)
        apiClient.get(endpoint: endpoint) { (result: Result<PersonTVShowCredits, TMDbError>) in
            completion(result.map { credits in
                let sortedCast = credits.cast.sorted()
                let sortedCrew = credits.crew.sorted()
                return PersonTVShowCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
            })
        }
    }

    func fetchImages(forPerson personID: Person.ID,
                     completion: @escaping (Result<PersonImageCollection, TMDbError>) -> Void) {
        apiClient.get(endpoint: PeopleEndpoint.images(personID: personID), completion: completion)
    }

    func fetchKnownFor(forPerson personID: Person.ID, completion: @escaping (Result<[Show], TMDbError>) -> Void) {
        fetchCombinedCredits(forPerson: personID) { result in
            completion(result.map(Self.knownForIn))
        }
    }

    func fetchPopular(page: Int?, completion: @escaping (Result<PersonPageableList, TMDbError>) -> Void) {
        apiClient.get(endpoint: PeopleEndpoint.popular(page: page), completion: completion)
    }

}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension TMDbPersonService {

    func detailsPublisher(forPerson id: Person.ID) -> AnyPublisher<Person, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.details(personID: id))
    }

    func combinedCreditsPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonCombinedCredits, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.combinedCredits(personID: personID))
            .map { (credits: PersonCombinedCredits) in
                let sortedCast = credits.cast.sorted()
                let sortedCrew = credits.crew.sorted()
                return PersonCombinedCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
            }
            .eraseToAnyPublisher()
    }

    func movieCreditsPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonMovieCredits, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.movieCredits(personID: personID))
            .map { (credits: PersonMovieCredits) in
                let sortedCast = credits.cast.sorted()
                let sortedCrew = credits.crew.sorted()
                return PersonMovieCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
            }
            .eraseToAnyPublisher()
    }

    func tvShowCreditsPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonTVShowCredits, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.tvShowCredits(personID: personID))
            .map { (credits: PersonTVShowCredits) in
                let sortedCast = credits.cast.sorted()
                let sortedCrew = credits.crew.sorted()
                return PersonTVShowCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
            }
            .eraseToAnyPublisher()
    }

    func imagesPublisher(forPerson personID: Person.ID) -> AnyPublisher<PersonImageCollection, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.images(personID: personID))
    }

    func knownForPublisher(forPerson personID: Person.ID) -> AnyPublisher<[Show], TMDbError> {
        combinedCreditsPublisher(forPerson: personID)
            .map(Self.knownForIn)
            .eraseToAnyPublisher()
    }

    func popularPublisher(page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.popular(page: page))
    }

}
#endif

#if swift(>=5.5)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension TMDbPersonService {

    func details(forPerson id: Person.ID) async throws -> Person {
        try await apiClient.get(endpoint: PeopleEndpoint.details(personID: id))
    }

    func combinedCredits(forPerson personID: Person.ID) async throws -> PersonCombinedCredits {
        let endpoint = PeopleEndpoint.combinedCredits(personID: personID)
        let credits: PersonCombinedCredits = try await apiClient.get(endpoint: endpoint)
        let sortedCast = credits.cast.sorted()
        let sortedCrew = credits.crew.sorted()
        return PersonCombinedCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
    }

    func movieCredits(forPerson personID: Person.ID) async throws -> PersonMovieCredits {
        let endpoint = PeopleEndpoint.movieCredits(personID: personID)
        let credits: PersonMovieCredits = try await apiClient.get(endpoint: endpoint)
        let sortedCast = credits.cast.sorted()
        let sortedCrew = credits.crew.sorted()
        return PersonMovieCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
    }

    func tvShowCredits(forPerson personID: Person.ID) async throws -> PersonTVShowCredits {
        let endpoint = PeopleEndpoint.tvShowCredits(personID: personID)
        let credits: PersonTVShowCredits = try await apiClient.get(endpoint: endpoint)
        let sortedCast = credits.cast.sorted()
        let sortedCrew = credits.crew.sorted()
        return PersonTVShowCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
    }

    func images(forPerson personID: Person.ID) async throws -> PersonImageCollection {
        try await apiClient.get(endpoint: PeopleEndpoint.images(personID: personID))
    }

    func knownFor(forPerson personID: Person.ID) async throws -> [Show] {
        let credits: PersonCombinedCredits = try await combinedCredits(forPerson: personID)
        return Self.knownForIn(credits: credits)
    }

    func popular(page: Int?) async throws -> PersonPageableList {
        try await apiClient.get(endpoint: PeopleEndpoint.popular(page: page))
    }

}
#endif

extension TMDbPersonService {

    private static func knownForIn(credits: PersonCombinedCredits) -> [Show] {
        let topShows = credits.allShows
            .sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }

        return Array(topShows.prefix(10))
    }

}
