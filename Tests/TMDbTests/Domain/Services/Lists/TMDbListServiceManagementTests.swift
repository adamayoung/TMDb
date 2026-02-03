//
//  TMDbListServiceManagementTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .list))
struct TMDbListServiceManagementTests {

    var service: TMDbListService!
    var apiClient: MockAPIClient!
    var session: Session!

    init() {
        self.session = Session(success: true, sessionID: "abc123")
        self.apiClient = MockAPIClient()
        self.service = TMDbListService(apiClient: apiClient)
    }

    @Test("create with all parameters returns create list result")
    func createWithAllParametersReturnsCreateListResult() async throws {
        let expectedResult = CreateListResult.mock()
        apiClient.addResponse(.success(expectedResult))
        let name = "My Awesome List"
        let description = "A great collection of films"
        let language = "en"
        let isPublic = true
        let expectedRequest = CreateListRequest(
            name: name,
            description: description,
            language: language,
            isPublic: isPublic,
            sessionID: session.sessionID
        )

        let result = try await service.create(
            name: name,
            description: description,
            language: language,
            isPublic: isPublic,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CreateListRequest == expectedRequest)
    }

    @Test("create with minimal parameters returns create list result")
    func createWithMinimalParametersReturnsCreateListResult() async throws {
        let expectedResult = CreateListResult.mock()
        apiClient.addResponse(.success(expectedResult))
        let name = "Simple List"
        let expectedRequest = CreateListRequest(
            name: name,
            description: nil,
            language: nil,
            isPublic: nil,
            sessionID: session.sessionID
        )

        let result = try await service.create(
            name: name,
            description: nil,
            language: nil,
            isPublic: nil,
            session: session
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? CreateListRequest == expectedRequest)
    }

    @Test("create when errors throws TMDbError")
    func createWhenErrorsThrowsTMDbError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.create(
                name: "Test",
                description: nil,
                language: nil,
                isPublic: nil,
                session: session
            )
        }
    }

    @Test("delete succeeds")
    func deleteSucceeds() async throws {
        let listID = 1234
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = DeleteListRequest(listID: listID, sessionID: session.sessionID)

        try await service.delete(list: listID, session: session)

        #expect(apiClient.lastRequest as? DeleteListRequest == expectedRequest)
    }

    @Test("delete when errors throws TMDbError")
    func deleteWhenErrorsThrowsTMDbError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.delete(list: 1234, session: session)
        }
    }

    @Test("addItem succeeds")
    func addItemSucceeds() async throws {
        let mediaID = 550
        let listID = 1234
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddMediaRequest(
            mediaID: mediaID,
            listID: listID,
            sessionID: session.sessionID
        )

        try await service.addItem(mediaID: mediaID, toList: listID, session: session)

        #expect(apiClient.lastRequest as? AddMediaRequest == expectedRequest)
    }

    @Test("addItem when errors throws TMDbError")
    func addItemWhenErrorsThrowsTMDbError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.addItem(mediaID: 550, toList: 1234, session: session)
        }
    }

    @Test("removeItem succeeds")
    func removeItemSucceeds() async throws {
        let mediaID = 550
        let listID = 1234
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = RemoveMediaRequest(
            mediaID: mediaID,
            listID: listID,
            sessionID: session.sessionID
        )

        try await service.removeItem(mediaID: mediaID, fromList: listID, session: session)

        #expect(apiClient.lastRequest as? RemoveMediaRequest == expectedRequest)
    }

    @Test("removeItem when errors throws TMDbError")
    func removeItemWhenErrorsThrowsTMDbError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.removeItem(mediaID: 550, fromList: 1234, session: session)
        }
    }

    @Test("clear succeeds")
    func clearSucceeds() async throws {
        let listID = 1234
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = ClearListRequest(listID: listID, sessionID: session.sessionID)

        try await service.clear(list: listID, session: session)

        #expect(apiClient.lastRequest as? ClearListRequest == expectedRequest)
    }

    @Test("clear when errors throws TMDbError")
    func clearWhenErrorsThrowsTMDbError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            try await service.clear(list: 1234, session: session)
        }
    }

}
