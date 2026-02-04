//
//  TMDbTVSeriesServiceChangesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceChangesTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("changes for TV series returns change collection")
    func changesForTVSeriesReturnsChangeCollection() async throws {
        let expectedResult = ChangeCollection.mock()
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesChangesRequest(id: tvSeriesID)

        let result = try await service.changes(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesChangesRequest == expectedRequest)
    }

    @Test("changes for TV series with dates returns change collection")
    func changesForTVSeriesWithDatesReturnsChangeCollection() async throws {
        let expectedResult = ChangeCollection.mock()
        let tvSeriesID = 1
        let startDate = Date(timeIntervalSince1970: 1_704_067_200)
        let endDate = Date(timeIntervalSince1970: 1_704_153_600)
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesChangesRequest(
            id: tvSeriesID,
            startDate: startDate,
            endDate: endDate,
            page: 2
        )

        let result = try await service.changes(
            forTVSeries: tvSeriesID,
            startDate: startDate,
            endDate: endDate,
            page: 2
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesChangesRequest == expectedRequest)
    }

    @Test("changes for TV series when errors throws error")
    func changesForTVSeriesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.changes(forTVSeries: tvSeriesID)
        }
    }

    @Test("latest returns TV series")
    func latestReturnsTVSeries() async throws {
        let expectedResult = TVSeries.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = LatestTVSeriesRequest()

        let result = try await service.latest()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? LatestTVSeriesRequest == expectedRequest)
    }

    @Test("latest when errors throws error")
    func latestWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.latest()
        }
    }

    @Test("changes returns changed ID collection")
    func changesReturnsChangedIDCollection() async throws {
        let expectedResult = ChangedIDCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesChangesListRequest()

        let result = try await service.changes()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesChangesListRequest == expectedRequest)
    }

    @Test("changes with dates returns changed ID collection")
    func changesWithDatesReturnsChangedIDCollection() async throws {
        let expectedResult = ChangedIDCollection.mock()
        let startDate = Date(timeIntervalSince1970: 1_704_067_200)
        let endDate = Date(timeIntervalSince1970: 1_704_153_600)
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: 2
        )

        let result = try await service.changes(startDate: startDate, endDate: endDate, page: 2)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesChangesListRequest == expectedRequest)
    }

    @Test("changes when errors throws error")
    func changesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.changes()
        }
    }

}
