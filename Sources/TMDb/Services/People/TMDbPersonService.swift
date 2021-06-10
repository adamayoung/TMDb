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

extension TMDbPersonService {

    private static func knownForIn(credits: PersonCombinedCredits) -> [Show] {
        let topCastShows = Array(credits.cast.prefix(10))
        let topCrewShows = Array(credits.crew.prefix(10))
        var topShows = topCastShows + topCrewShows
        topShows = topShows.reduce([], { shows, show in
            var shows = shows
            if !shows.contains(where: { $0.id == show.id }) {
                shows.append(show)
            }

            return shows
        })

        topShows.sort { $0.popularity ?? 0 > $1.popularity ?? 0 }

        return Array(topShows.prefix(10))
    }

}
