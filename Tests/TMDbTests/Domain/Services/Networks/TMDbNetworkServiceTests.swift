//
//  TMDbNetworkServiceTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
