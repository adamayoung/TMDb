//
//  MockGenreServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

@Suite(.tags(.testingSupport, .mocks, .genre))
struct MockGenreServiceTests {

    var service: MockGenreService

    init() {
        self.service = MockGenreService()
    }

    @Test("movieGenres by default returns the sample genres")
    func movieGenresByDefaultReturnsSampleGenres() async throws {
        let result = try await service.movieGenres(language: nil)

        #expect(result == [Genre].samples)
    }

    @Test("movieGenres records the call with its arguments")
    func movieGenresRecordsCall() async throws {
        _ = try await service.movieGenres(language: "en")

        #expect(service.movieGenresCalls.count == 1)
        #expect(service.movieGenresCalls.first?.language == "en")
    }

    @Test("movieGenres throws the injected failure")
    func movieGenresThrowsInjectedFailure() async {
        service.movieGenresResult = .failure(.unknown)

        await #expect(throws: TMDbError.unknown) {
            try await service.movieGenres(language: nil)
        }
    }

    @Test("movieGenres returns the injected success value")
    func movieGenresReturnsInjectedSuccess() async throws {
        let injected = [Genre(id: 99, name: "Documentary")]
        service.movieGenresResult = .success(injected)

        let result = try await service.movieGenres(language: nil)

        #expect(result == injected)
    }

    @Test("tvSeriesGenres by default returns the sample genres and records the call")
    func tvSeriesGenresByDefaultReturnsSampleGenres() async throws {
        let result = try await service.tvSeriesGenres(language: "fr")

        #expect(result == [Genre].samples)
        #expect(service.tvSeriesGenresCalls.first?.language == "fr")
    }

    @Test("concurrent calls over one instance record every call without racing")
    func concurrentCallsAreThreadSafe() async {
        let iterations = 100

        await withTaskGroup(of: Void.self) { group in
            for index in 0 ..< iterations {
                group.addTask {
                    _ = try? await service.movieGenres(language: "\(index)")
                }
            }
        }

        #expect(service.movieGenresCalls.count == iterations)
    }

}
