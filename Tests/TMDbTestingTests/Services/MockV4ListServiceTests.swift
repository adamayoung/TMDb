//
//  MockV4ListServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

@Suite(.tags(.testingSupport, .mocks, .list))
struct MockV4ListServiceTests {

    var service: MockV4ListService

    init() {
        self.service = MockV4ListService()
    }

    // MARK: - Defaults

    @Test("details returns the sample by default")
    func detailsReturnsSampleByDefault() async throws {
        let result = try await service.details(forList: 1)

        #expect(result == .sample)
    }

    @Test("itemStatus reports present by default")
    func itemStatusReturnsTrueByDefault() async throws {
        let result = try await service.itemStatus(forMedia: 550, ofType: .movie, inList: 1)

        #expect(result)
    }

    @Test("the sample list holds both a movie and a TV series")
    func sampleListMixesMediaTypes() throws {
        // The mixed list is the whole point of v4, so the default sample has to
        // exercise it rather than being movies-only.
        let list = V4List.sample

        let movie = try #require(list.items.first { $0.id == 550 })
        let tvSeries = try #require(list.items.first { $0.id == 1399 })

        guard case .movie = movie.media else {
            Issue.record("expected 550 to be a movie")
            return
        }
        guard case .tvSeries = tvSeries.media else {
            Issue.record("expected 1399 to be a TV series")
            return
        }
    }

    // MARK: - Recording

    @Test("details records every argument it was called with")
    func detailsRecordsArguments() async throws {
        _ = try await service.details(
            forList: 42,
            page: 2,
            sortedBy: .title(descending: true),
            language: "en",
            accessToken: "token"
        )

        #expect(service.detailsCalls.count == 1)
        let call = try #require(service.detailsCalls.first)
        #expect(call.listID == 42)
        #expect(call.page == 2)
        #expect(call.sortedBy == .title(descending: true))
        #expect(call.language == "en")
        #expect(call.accessToken == "token")
    }

    @Test("the details convenience forwards nils to the requirement")
    func detailsConvenienceForwardsNils() async throws {
        // The conveniences drop parameters rather than defaulting them; this
        // pins that they still reach the requirement with nil.
        _ = try await service.details(forList: 42)

        let call = try #require(service.detailsCalls.first)
        #expect(call.page == nil)
        #expect(call.sortedBy == nil)
        #expect(call.language == nil)
        #expect(call.accessToken == nil)
    }

    @Test("addItems records the items and the list")
    func addItemsRecordsArguments() async throws {
        _ = try await service.addItems(
            V4ListMediaItem.samples, toList: 42, accessToken: "token"
        )

        let call = try #require(service.addItemsCalls.first)
        #expect(call.items == V4ListMediaItem.samples)
        #expect(call.listID == 42)
        #expect(call.accessToken == "token")
    }

    @Test("update records the attributes")
    func updateRecordsAttributes() async throws {
        try await service.update(list: 42, name: "Renamed", accessToken: "token")

        let call = try #require(service.updateCalls.first)
        #expect(call.listID == 42)
        #expect(call.attributes.name == "Renamed")
    }

    // MARK: - Injection

    @Test("details returns the injected success")
    func detailsReturnsInjectedSuccess() async throws {
        let expectedResult = V4List(
            id: 7,
            name: "Injected",
            isPublic: false,
            createdBy: .sample,
            itemCount: 0,
            sortBy: "title.asc",
            languageCode: "en",
            countryCode: "GB"
        )
        service.detailsResult = .success(expectedResult)

        let result = try await service.details(forList: 7)

        #expect(result == expectedResult)
    }

    @Test("details throws the injected failure")
    func detailsThrowsInjectedFailure() async throws {
        service.detailsResult = .failure(.notFound(TMDbErrorContext()))

        await #expect(throws: TMDbError.notFound(TMDbErrorContext())) {
            _ = try await service.details(forList: 1)
        }
    }

    @Test("removeItems can be stubbed with the partial failure TMDb really sends")
    func removeItemsPartialFailure() async throws {
        service.removeItemsResult = .success(.partialFailureSample)

        let result = try await service.removeItems(
            [.movie(550)], fromList: 1, accessToken: "token"
        )

        #expect(result.success)
        #expect(result.allItemsSucceeded == false)
        #expect(result.failures.count == 1)
    }

    @Test("delete throws the injected failure")
    func deleteThrowsInjectedFailure() async throws {
        service.deleteResult = .failure(.unauthorised(TMDbErrorContext()))

        await #expect(throws: TMDbError.unauthorised(TMDbErrorContext())) {
            try await service.delete(list: 1, accessToken: "token")
        }
    }

}
