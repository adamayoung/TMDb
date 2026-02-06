//
//  TMDbChangesServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .changes))
struct TMDbChangesServiceTests {

    var service: TMDbChangesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbChangesService(apiClient: apiClient)
    }

    @Test("movieChanges returns changed IDs")
    func movieChangesReturnsChangedIDs() async throws {
        let expectedResult = ChangedIDCollection.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.movieChanges()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is MovieChangesListRequest)
    }

    @Test("movieChanges when errors throws error")
    func movieChangesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movieChanges()
        }
    }

    @Test("tvSeriesChanges returns changed IDs")
    func tvSeriesChangesReturnsChangedIDs() async throws {
        let expectedResult = ChangedIDCollection.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.tvSeriesChanges()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is TVSeriesChangesListRequest)
    }

    @Test("tvSeriesChanges when errors throws error")
    func tvSeriesChangesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeriesChanges()
        }
    }

    @Test("personChanges returns changed IDs")
    func personChangesReturnsChangedIDs() async throws {
        let expectedResult = ChangedIDCollection.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.personChanges()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is PersonChangesListRequest)
    }

    @Test("personChanges when errors throws error")
    func personChangesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.personChanges()
        }
    }

    @Test("movieDetails returns change collection")
    func movieDetailsReturnsChangeCollection() async throws {
        let expectedResult = ChangeCollection.mock()
        let movieID = 550
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.movieDetails(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is MovieChangesRequest)
    }

    @Test("movieDetails when errors throws error")
    func movieDetailsWhenErrorsThrowsError() async throws {
        let movieID = 550
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movieDetails(forMovie: movieID)
        }
    }

    @Test("tvSeriesDetails returns change collection")
    func tvSeriesDetailsReturnsChangeCollection() async throws {
        let expectedResult = ChangeCollection.mock()
        let tvSeriesID = 1399
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.tvSeriesDetails(
            forTVSeries: tvSeriesID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is TVSeriesChangesRequest)
    }

    @Test("tvSeriesDetails when errors throws error")
    func tvSeriesDetailsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1399
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeriesDetails(
                forTVSeries: tvSeriesID
            )
        }
    }

    @Test("personDetails returns change collection")
    func personDetailsReturnsChangeCollection() async throws {
        let expectedResult = ChangeCollection.mock()
        let personID = 287
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.personDetails(forPerson: personID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is PersonChangesRequest)
    }

    @Test("personDetails when errors throws error")
    func personDetailsWhenErrorsThrowsError() async throws {
        let personID = 287
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.personDetails(forPerson: personID)
        }
    }

    @Test("tvSeasonDetails returns change collection")
    func tvSeasonDetailsReturnsChangeCollection() async throws {
        let expectedResult = ChangeCollection.mock()
        let seasonID = 3624
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.tvSeasonDetails(
            forSeason: seasonID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is TVSeasonChangesRequest)
    }

    @Test("tvSeasonDetails when errors throws error")
    func tvSeasonDetailsWhenErrorsThrowsError() async throws {
        let seasonID = 3624
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeasonDetails(forSeason: seasonID)
        }
    }

    @Test("tvEpisodeDetails returns change collection")
    func tvEpisodeDetailsReturnsChangeCollection() async throws {
        let expectedResult = ChangeCollection.mock()
        let episodeID = 62085
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.tvEpisodeDetails(
            forEpisode: episodeID
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is TVEpisodeChangesRequest)
    }

    @Test("tvEpisodeDetails when errors throws error")
    func tvEpisodeDetailsWhenErrorsThrowsError() async throws {
        let episodeID = 62085
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvEpisodeDetails(
                forEpisode: episodeID
            )
        }
    }

}
