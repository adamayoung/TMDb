//
//  TMDbMovieServiceChangesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceChangesTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("changes for movie with default parameter values returns changes")
    func changesForMovieWithDefaultParameterValuesReturnsChanges() async throws {
        let expectedResult = ChangeCollection.mock()
        let movieID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieChangesRequest(
            id: movieID,
            startDate: nil,
            endDate: nil,
            page: nil
        )

        let result = try await (service as MovieService).changes(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieChangesRequest == expectedRequest)
    }

    @Test("changes for movie with start date, end date and page returns changes")
    func changesForMovieWithStartDateAndEndDateAndPageReturnsChanges() async throws {
        let expectedResult = ChangeCollection.mock()
        let movieID = 1
        let startDate = Date(timeIntervalSince1970: 1_704_067_200)
        let endDate = Date(timeIntervalSince1970: 1_735_689_600)
        let page = 2
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieChangesRequest(
            id: movieID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let result = try await service.changes(
            forMovie: movieID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieChangesRequest == expectedRequest)
    }

    @Test("changes for movie when errors throws error")
    func changesForMovieWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.changes(forMovie: movieID)
        }
    }

    @Test("changes list with default parameter values returns changed IDs")
    func changesListWithDefaultParameterValuesReturnsChangedIDs() async throws {
        let expectedResult = ChangedIDCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieChangesListRequest(
            startDate: nil,
            endDate: nil,
            page: nil
        )

        let result = try await (service as MovieService).changes()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieChangesListRequest == expectedRequest)
    }

    @Test("changes list with start date, end date and page returns changed IDs")
    func changesListWithStartDateAndEndDateAndPageReturnsChangedIDs() async throws {
        let expectedResult = ChangedIDCollection.mock()
        let startDate = Date(timeIntervalSince1970: 1_704_067_200)
        let endDate = Date(timeIntervalSince1970: 1_735_689_600)
        let page = 2
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let result = try await service.changes(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieChangesListRequest == expectedRequest)
    }

    @Test("changes list when errors throws error")
    func changesListWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.changes()
        }
    }

}
