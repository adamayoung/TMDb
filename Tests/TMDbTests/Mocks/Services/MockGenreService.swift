@testable import TMDb
import XCTest

final class MockGenreService: GenreService {

    var movieGenres: [Genre]?

    func movieGenres() async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let movieGenres = self.movieGenres else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: movieGenres)
        }
    }

}
