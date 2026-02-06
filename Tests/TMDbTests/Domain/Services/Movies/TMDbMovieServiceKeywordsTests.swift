//
//  TMDbMovieServiceKeywordsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceKeywordsTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("keywords returns keyword collection")
    func keywordsReturnsKeywordCollection() async throws {
        let movieID = 550
        let response = MovieKeywordsResponse(
            id: movieID,
            keywords: [
                Keyword(id: 851, name: "dual identity"),
                Keyword(id: 818, name: "based on novel or book")
            ]
        )
        apiClient.addResponse(.success(response))
        let expectedRequest = MovieKeywordsRequest(id: movieID)

        let result = try await service.keywords(forMovie: movieID)

        #expect(result.id == movieID)
        #expect(result.keywords.count == 2)
        #expect(result.keywords[0].id == 851)
        #expect(result.keywords[0].name == "dual identity")
        #expect(apiClient.lastRequest as? MovieKeywordsRequest == expectedRequest)
    }

    @Test("keywords when errors throws error")
    func keywordsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.keywords(forMovie: movieID)
        }
    }

    @Test("JSON decoding of MovieKeywordsResponse", .tags(.decoding))
    func decodeMovieKeywordsResponse() throws {
        let response = try JSONDecoder.theMovieDatabase.decode(
            MovieKeywordsResponse.self,
            fromResource: "movie-keywords"
        )

        #expect(response.id == 550)
        #expect(response.keywords.count == 2)
        #expect(response.keywords[0].id == 851)
        #expect(response.keywords[0].name == "dual identity")

        let collection = response.keywordCollection
        #expect(collection.id == 550)
        #expect(collection.keywords.count == 2)
    }

}
