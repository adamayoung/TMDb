import Foundation

final class TMDbPersonService: PersonService {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

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

extension TMDbPersonService {

    private static func knownForIn(credits: PersonCombinedCredits) -> [Show] {
        let topShows = credits.allShows
            .sorted { $0.popularity ?? 0 > $1.popularity ?? 0 }

        return Array(topShows.prefix(10))
    }

}
