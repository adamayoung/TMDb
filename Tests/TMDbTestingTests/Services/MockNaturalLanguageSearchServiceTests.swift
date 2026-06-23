//
//  MockNaturalLanguageSearchServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

@Suite(.tags(.testingSupport, .mocks))
struct MockNaturalLanguageSearchServiceTests {

    var service: MockNaturalLanguageSearchService

    init() {
        self.service = MockNaturalLanguageSearchService()
    }

    // MARK: - search

    @Test("search by default returns the sample result and records the call")
    func searchByDefaultReturnsSample() async throws {
        let result = try await service.search(matching: "sci-fi movies")

        #expect(result == .sample)
        #expect(service.searchCalls.count == 1)
        #expect(service.searchCalls.first?.prompt == "sci-fi movies")
    }

    @Test("search throws the injected NaturalLanguageSearchError failure")
    func searchThrowsInjectedFailure() async {
        service.searchResult = .failure(.outOfScope)

        await #expect(throws: NaturalLanguageSearchError.outOfScope) {
            try await service.search(matching: "the weather today")
        }
    }

    // MARK: - plan

    @Test("plan by default returns the sample plan and records the call")
    func planByDefaultReturnsSample() async throws {
        let result = try await service.plan(for: "movies with Tom Hanks")

        #expect(result == .sample)
        #expect(service.planCalls.first?.prompt == "movies with Tom Hanks")
    }

    @Test("plan throws the injected NaturalLanguageSearchError failure")
    func planThrowsInjectedFailure() async {
        service.planResult = .failure(.unsupportedLanguage)

        await #expect(throws: NaturalLanguageSearchError.unsupportedLanguage) {
            try await service.plan(for: "películas de acción")
        }
    }

    // MARK: - availability (settable property)

    @Test("availability by default returns the sample availability")
    func availabilityByDefaultReturnsSample() {
        #expect(service.availability == .sample)
    }

    @Test("setting availability changes the value returned by availability")
    func settingAvailabilityChangesValue() {
        let injected = NaturalLanguageSearchAvailability.unavailable(.deviceNotEligible)
        service.availability = injected

        #expect(service.availability == injected)
    }

}
