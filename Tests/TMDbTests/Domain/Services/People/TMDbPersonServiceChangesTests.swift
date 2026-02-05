//
//  TMDbPersonServiceChangesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct TMDbPersonServiceChangesTests {

    var service: TMDbPersonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbPersonService(apiClient: apiClient)
    }

    @Test(
        "changes with default parameters returns change collection"
    )
    func changesWithDefaultParametersReturnsChangeCollection()
    async throws {
        let personID = 500
        let expectedResult = ChangeCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonChangesRequest(
            id: personID,
            startDate: nil,
            endDate: nil,
            page: nil
        )

        let result = try await (service as PersonService)
            .changes(forPerson: personID)

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? PersonChangesRequest
                == expectedRequest
        )
    }

    @Test(
        "changes with parameters returns change collection"
    )
    func changesWithParametersReturnsChangeCollection()
    async throws {
        let personID = 500
        let startDate = Date(timeIntervalSince1970: 1_704_067_200)
        let endDate = Date(timeIntervalSince1970: 1_706_745_600)
        let page = 2
        let expectedResult = ChangeCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonChangesRequest(
            id: personID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let result = try await service.changes(
            forPerson: personID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? PersonChangesRequest
                == expectedRequest
        )
    }

    @Test("changes when errors throws error")
    func changesWhenErrorsThrowsError() async throws {
        let personID = 500
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.changes(forPerson: personID)
        }
    }

    @Test("latestPerson returns person")
    func latestPersonReturnsPerson() async throws {
        let expectedResult = Person.tomCruise
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = LatestPersonRequest()

        let result = try await service.latestPerson()

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? LatestPersonRequest
                == expectedRequest
        )
    }

    @Test("latestPerson when errors throws error")
    func latestPersonWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.latestPerson()
        }
    }

    @Test(
        "personChanges with default parameters returns changed IDs"
    )
    func personChangesWithDefaultParametersReturnsChangedIDs()
    async throws {
        let expectedResult = ChangedIDCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonChangesListRequest(
            startDate: nil,
            endDate: nil,
            page: nil
        )

        let result = try await (service as PersonService)
            .personChanges()

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? PersonChangesListRequest
                == expectedRequest
        )
    }

    @Test(
        "personChanges with parameters returns changed IDs"
    )
    func personChangesWithParametersReturnsChangedIDs()
    async throws {
        let startDate = Date(timeIntervalSince1970: 1_704_067_200)
        let endDate = Date(timeIntervalSince1970: 1_706_745_600)
        let page = 2
        let expectedResult = ChangedIDCollection.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let result = try await service.personChanges(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? PersonChangesListRequest
                == expectedRequest
        )
    }

    @Test("personChanges when errors throws error")
    func personChangesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.personChanges()
        }
    }

}
