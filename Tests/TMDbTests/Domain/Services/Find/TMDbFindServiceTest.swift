//
//  TMDbFindServiceTest.swift
//  TMDb
//
//  Created by MLabs on 23/06/2025.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .find))
struct TMDbFindServiceTest {
    
    var service: TMDbFindService!
    var apiClient: MockAPIClient!
    
    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbFindService(apiClient: apiClient)
    }
    
    @Test("find by external id")
    func movieGenresWithDefaultParameterValuesReturnsGenres() async throws {

        let expectedRequest = FindRequest(id: "tt11952708",
                                          externalSource: .imdbID)

        let result = try await (service as FindService).findId("tt11952708",
                                                               type: .imdbID)
        
        print(result)
    }
}
