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

    func details(forPerson id: Person.ID) async throws -> Person {
        lastPersonDetailsID = id

        return try await withCheckedThrowingContinuation { continuation in
            guard let personDetails = self.personDetails else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: personDetails)
        }
    }

    func combinedCredits(forPerson personID: Person.ID) async throws -> PersonCombinedCredits {
        lastCombinedCredtsPersonID = personID

        return try await withCheckedThrowingContinuation { continuation in
            guard let combinedCredits = self.combinedCredits else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: combinedCredits)
        }
    }

    func movieCredits(forPerson personID: Person.ID) async throws -> PersonMovieCredits {
        lastMovieCreditsPersonID = personID

        return try await withCheckedThrowingContinuation { continuation in
            guard let movieCredits = self.movieCredits else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: movieCredits)
        }
    }

    func tvShowCredits(forPerson personID: Person.ID) async throws -> PersonTVShowCredits {
        lastTVShowCreditsPersonID = personID

        return try await withCheckedThrowingContinuation { continuation in
            guard let tvShowCredits = self.tvShowCredits else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: tvShowCredits)
        }
    }

    func images(forPerson personID: Person.ID) async throws -> PersonImageCollection {
        lastImagesPersonID = personID

        return try await withCheckedThrowingContinuation { continuation in
            guard let images = self.images else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: images)
        }
    }

    func knownFor(forPerson personID: Person.ID) async throws -> [Show] {
        lastKnownForPersonID = personID

        return try await withCheckedThrowingContinuation { continuation in
            guard let knownFor = self.knownFor else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: knownFor)
        }
    }

    func popular(page: Int?) async throws -> PersonPageableList {
        lastPopularPage = page

        return try await withCheckedThrowingContinuation { continuation in
            guard let popular = self.popular else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: popular)
        }
    }

}
