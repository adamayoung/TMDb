import Foundation

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension PersonService {

    /// Returns the primary information about a person.
    ///
    /// - Note: [TMDb API - People: Details](https://developers.themoviedb.org/3/people/get-person-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the person.
    ///
    /// - Returns: The matching person.
    func details(forPerson id: Person.ID) async throws -> Person {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchDetails(forPerson: id, completion: continuation.resume(with:))
        }
    }

    /// Returns the combined movie and TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: Combined Credits](https://developers.themoviedb.org/3/people/get-person-combined-credits)
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's combined movie and TV show credits..
    func combinedCredits(forPerson personID: Person.ID) async throws -> PersonCombinedCredits {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchCombinedCredits(forPerson: personID, completion: continuation.resume(with:))
        }
    }

    /// Returns the movie credits of a person.
    ///
    /// - Note: [TMDb API - People: Movie Credits](https://developers.themoviedb.org/3/people/get-person-movie-credits)
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's movie credits.
    func movieCredits(forPerson personID: Person.ID) async throws -> PersonMovieCredits {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchMovieCredits(forPerson: personID, completion: continuation.resume(with:))
        }
    }

    /// Returns the TV show credits of a person.
    ///
    /// - Note: [TMDb API - People: TV Show Credits](https://developers.themoviedb.org/3/people/get-person-tv-credits)
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's TV show credits.
    func tvShowCredits(forPerson personID: Person.ID) async throws -> PersonTVShowCredits {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchTVShowCredits(forPerson: personID, completion: continuation.resume(with:))
        }
    }

    /// Returns the images for a person.
    ///
    /// - Note: [TMDb API - People: Images](https://developers.themoviedb.org/3/people/get-person-images)
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's images.
    func images(forPerson personID: Person.ID) async throws -> PersonImageCollection {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchImages(forPerson: personID, completion: continuation.resume(with:))
        }
    }

    /// Returns the list of known for shows for a person.
    ///
    /// - Parameters:
    ///     - personID: The identifier of the person.
    ///
    /// - Returns: The matching person's show credits.
    func knownFor(forPerson personID: Person.ID) async throws -> [Show] {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchKnownFor(forPerson: personID, completion: continuation.resume(with:))
        }
    }

    /// Returns the list of popular people.
    ///
    /// - Note: [TMDb API - People: Popular](https://developers.themoviedb.org/3/people/get-popular-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - page: The page of results to return.
    ///
    /// - Returns: Current popular people as a pageable list.
    func popular(page: Int? = nil) async throws -> PersonPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchPopular(page: page, completion: continuation.resume(with:))
        }
    }

}
#endif
