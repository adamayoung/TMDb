//
//  TMDbTVSeriesServiceMetadataExtrasTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceMetadataExtrasTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("keywords returns keyword collection")
    func keywordsReturnsKeywordCollection() async throws {
        let expectedResult = KeywordCollection.mock()
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesKeywordsRequest(id: tvSeriesID)

        let result = try await service.keywords(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesKeywordsRequest == expectedRequest)
    }

    @Test("keywords when errors throws error")
    func keywordsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.keywords(forTVSeries: tvSeriesID)
        }
    }

    @Test("alternativeTitles returns alternative title collection")
    func alternativeTitlesReturnsAlternativeTitleCollection() async throws {
        let expectedResult = AlternativeTitleCollection.mock()
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesAlternativeTitlesRequest(id: tvSeriesID)

        let result = try await service.alternativeTitles(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesAlternativeTitlesRequest == expectedRequest)
    }

    @Test("alternativeTitles when errors throws error")
    func alternativeTitlesWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.alternativeTitles(forTVSeries: tvSeriesID)
        }
    }

    @Test("translations returns translation collection")
    func translationsReturnsTranslationCollection() async throws {
        let expectedResult = TranslationCollection<TVSeriesTranslationData>.mock()
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesTranslationsRequest(id: tvSeriesID)

        let result = try await service.translations(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesTranslationsRequest == expectedRequest)
    }

    @Test("translations when errors throws error")
    func translationsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.translations(forTVSeries: tvSeriesID)
        }
    }

    @Test("lists returns media pageable list")
    func listsReturnsMediaListSummaryPageableList() async throws {
        let expectedResult = MediaListSummaryPageableList.mock()
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesListsRequest(id: tvSeriesID, page: nil, language: nil)

        let result = try await service.lists(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesListsRequest == expectedRequest)
    }

    @Test("lists with page and language returns media pageable list")
    func listsWithPageAndLanguageReturnsMediaListSummaryPageableList() async throws {
        let expectedResult = MediaListSummaryPageableList.mock()
        let tvSeriesID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesListsRequest(id: tvSeriesID, page: 2, language: "de")

        let result = try await service.lists(forTVSeries: tvSeriesID, page: 2, language: "de")

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesListsRequest == expectedRequest)
    }

    @Test("lists when errors throws error")
    func listsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.lists(forTVSeries: tvSeriesID)
        }
    }

}
