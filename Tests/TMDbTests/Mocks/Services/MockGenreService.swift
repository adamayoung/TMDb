@testable import TMDb
import XCTest

final class MockGenreService: GenreService {

    var movieGenres: [Genre]?
    var tvShowGenres: [Genre]?

    func movieGenres() async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let movieGenres = self.movieGenres else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: movieGenres)
        }
    }

    func tvShowGenres() async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let tvShowGenres = self.tvShowGenres else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: tvShowGenres)
        }
    }

}
