import Combine
import Foundation

final class TMDbPersonService: PersonService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchDetails(forPerson id: Person.ID) -> AnyPublisher<Person, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.details(personID: id))
    }

    func fetchCombinedCredits(
        forPerson personID: Person.ID) -> AnyPublisher<PersonCombinedCredits, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.combinedCredits(personID: personID))
            .map { (credits: PersonCombinedCredits) in
                let sortedCast = credits.cast.sorted(by: Self.showSort)
                let sortedCrew = credits.crew.sorted(by: Self.showSort)
                return PersonCombinedCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
            }
            .eraseToAnyPublisher()
    }

    func fetchMovieCredits(forPerson personID: Person.ID) -> AnyPublisher<PersonMovieCredits, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.movieCredits(personID: personID))
            .map { (credits: PersonMovieCredits) in
                let sortedCast = credits.cast.sorted(by: Self.movieSort)
                let sortedCrew = credits.crew.sorted(by: Self.movieSort)
                return PersonMovieCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
            }
            .eraseToAnyPublisher()
    }

    func fetchTVShowCredits(
        forPerson personID: Person.ID) -> AnyPublisher<PersonTVShowCredits, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.tvShowCredits(personID: personID))
            .map { (credits: PersonTVShowCredits) in
                let sortedCast = credits.cast.sorted(by: Self.tvShowSort)
                let sortedCrew = credits.crew.sorted(by: Self.tvShowSort)
                return PersonTVShowCredits(id: credits.id, cast: sortedCast, crew: sortedCrew)
            }
            .eraseToAnyPublisher()
    }

    func fetchImages(forPerson personID: Person.ID) -> AnyPublisher<PersonImageCollection, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.images(personID: personID))
    }

    func fetchKnownFor(forPerson personID: Person.ID) -> AnyPublisher<[Show], TMDbError> {
        fetchCombinedCredits(forPerson: personID)
            .map(Self.knownForIn)
            .eraseToAnyPublisher()
    }

    func fetchPopular(page: Int?) -> AnyPublisher<PersonPageableList, TMDbError> {
        apiClient.get(endpoint: PeopleEndpoint.popular(page: page))
    }

}

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

extension TMDbPersonService {

    private static func showSort(lhs: Show, rhs: Show) -> Bool {
        guard let lhsDate = lhs.date else {
            return false
        }

        guard let rhsDate = rhs.date else {
            return true
        }

        return lhsDate > rhsDate
    }

    private static func movieSort(lhs: Movie, rhs: Movie) -> Bool {
        guard let lhsDate = lhs.releaseDate else {
            return false
        }

        guard let rhsDate = rhs.releaseDate else {
            return true
        }

        return lhsDate > rhsDate
    }

    private static func tvShowSort(lhs: TVShow, rhs: TVShow) -> Bool {
        guard let lhsDate = lhs.firstAirDate else {
            return false
        }

        guard let rhsDate = rhs.firstAirDate else {
            return true
        }

        return lhsDate > rhsDate
    }

}
