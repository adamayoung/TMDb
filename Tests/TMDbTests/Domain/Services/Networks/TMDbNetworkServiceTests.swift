//
//  TMDbNetworkServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .network))
struct TMDbNetworkServiceTests {

    var service: TMDbNetworkService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbNetworkService(apiClient: apiClient)
    }

    @Test("details returns network")
    func detailsReturnsNetwork() async throws {
        let expectedResult = Network.hbo
        let networkID = expectedResult.id
        let expectedRequest = NetworkRequest(id: networkID)

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.details(forNetwork: networkID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? NetworkRequest == expectedRequest)
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let networkID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(forNetwork: networkID)
        }
    }

    @Test("alternativeNames returns alternative names")
    func alternativeNamesReturnsAlternativeNames() async throws {
        let networkID = 49
        let expectedResult = [NetworkAlternativeName.mock()]
        let expectedRequest = NetworkAlternativeNamesRequest(id: networkID)
        let response = NetworkAlternativeNamesResponse(id: networkID, results: expectedResult)

        apiClient.addResponse(.success(response))

        let result = try await service.alternativeNames(forNetwork: networkID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? NetworkAlternativeNamesRequest == expectedRequest)
    }

    @Test("alternativeNames when errors throws error")
    func alternativeNamesWhenErrorsThrowsError() async throws {
        let networkID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.alternativeNames(forNetwork: networkID)
        }
    }

    @Test("images returns logos")
    func imagesReturnsLogos() async throws {
        let networkID = 49
        let expectedResult = [NetworkLogo.mock()]
        let expectedRequest = NetworkImagesRequest(id: networkID)
        let response = NetworkLogosResponse(id: networkID, logos: expectedResult)

        apiClient.addResponse(.success(response))

        let result = try await service.images(forNetwork: networkID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? NetworkImagesRequest == expectedRequest)
    }

    @Test("images when errors throws error")
    func imagesWhenErrorsThrowsError() async throws {
        let networkID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.images(forNetwork: networkID)
        }
    }

}
