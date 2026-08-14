//
//  PersonServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``PersonService``.
///
/// Each convenience drops its parameters rather than defaulting them, so that
/// its signature cannot witness the requirement it forwards to. These tests
/// assert the other half of that contract: the convenience still reaches the
/// requirement, passing each omitted parameter's default.
///
/// Where a requirement has more than one droppable parameter there is one
/// overload per proper subset of them, and one test per *site* drives the whole
/// set: it calls every overload in turn and checks the recorded call straight
/// after each one. A test per overload would assert the same thing several
/// times over, since the mock records every call into one array. Sites with
/// three or more droppable parameters are split a tier at a time, by how many
/// parameters the overload drops.
///
/// They live in this target on purpose. `TMDbTesting`'s mocks implement the
/// *requirements* and never the conveniences, and this target imports through
/// the public API with no `@testable` — so the conformance exercised here is
/// exactly the one a third-party conformer has, which is the only population
/// the hazard can reach.
///
@Suite(.tags(.testingSupport, .mocks, .person))
struct PersonServiceConvenienceTests {

    var service: MockPersonService

    init() {
        self.service = MockPersonService()
    }

    @Test("details(forPerson:) forwards a nil language to the requirement")
    func detailsForwardsNilLanguage() async throws {
        _ = try await service.details(forPerson: 500)

        #expect(service.detailsCalls.count == 1)
        let call = try #require(service.detailsCalls.first)
        #expect(call.language == nil)
        #expect(call.personID == 500)
    }

    @Test("details(forPerson:appending:) forwards a nil language to the requirement")
    func detailsAppendingForwardsNilLanguage() async throws {
        _ = try await service.details(forPerson: 500, appending: .movieCredits)

        #expect(service.detailsAppendingCalls.count == 1)
        let call = try #require(service.detailsAppendingCalls.first)
        #expect(call.language == nil)
        #expect(call.personID == 500)
        #expect(call.appending == .movieCredits)
    }

    @Test("combinedCredits(forPerson:) forwards a nil language to the requirement")
    func combinedCreditsForwardsNilLanguage() async throws {
        _ = try await service.combinedCredits(forPerson: 500)

        #expect(service.combinedCreditsCalls.count == 1)
        let call = try #require(service.combinedCreditsCalls.first)
        #expect(call.language == nil)
        #expect(call.personID == 500)
    }

    @Test("movieCredits(forPerson:) forwards a nil language to the requirement")
    func movieCreditsForwardsNilLanguage() async throws {
        _ = try await service.movieCredits(forPerson: 500)

        #expect(service.movieCreditsCalls.count == 1)
        let call = try #require(service.movieCreditsCalls.first)
        #expect(call.language == nil)
        #expect(call.personID == 500)
    }

    @Test("tvSeriesCredits(forPerson:) forwards a nil language to the requirement")
    func tvSeriesCreditsForwardsNilLanguage() async throws {
        _ = try await service.tvSeriesCredits(forPerson: 500)

        #expect(service.tvSeriesCreditsCalls.count == 1)
        let call = try #require(service.tvSeriesCreditsCalls.first)
        #expect(call.language == nil)
        #expect(call.personID == 500)
    }

    @Test("taggedImages(forPerson:) forwards a nil page to the requirement")
    func taggedImagesForwardsNilPage() async throws {
        _ = try await service.taggedImages(forPerson: 500)

        #expect(service.taggedImagesCalls.count == 1)
        let call = try #require(service.taggedImagesCalls.first)
        #expect(call.page == nil)
        #expect(call.personID == 500)
    }

    @Test("changes(forPerson:startDate:endDate:page:) dropping one parameter")
    func changesForPersonDroppingOneForwardsTheRest() async throws {
        _ = try await service.changes(
            forPerson: 500,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.changesForPersonCalls.last)
        #expect(call.personID == 500)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(forPerson: 500, startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.changesForPersonCalls.last)
        #expect(call.personID == 500)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.changes(forPerson: 500, endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.changesForPersonCalls.last)
        #expect(call.personID == 500)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.changesForPersonCalls.count == 3)
    }

    @Test("changes(forPerson:startDate:endDate:page:) dropping two parameters")
    func changesForPersonDroppingTwoForwardsTheRest() async throws {
        _ = try await service.changes(forPerson: 500, startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.changesForPersonCalls.last)
        #expect(call.personID == 500)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.changes(forPerson: 500, endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.changesForPersonCalls.last)
        #expect(call.personID == 500)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(forPerson: 500, page: 3)
        call = try #require(service.changesForPersonCalls.last)
        #expect(call.personID == 500)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.changesForPersonCalls.count == 3)
    }

    @Test("changes(forPerson:startDate:endDate:page:) dropping three parameters")
    func changesForPersonDroppingThreeForwardsTheRest() async throws {
        _ = try await service.changes(forPerson: 500)
        let call = try #require(service.changesForPersonCalls.last)
        #expect(call.personID == 500)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.changesForPersonCalls.count == 1)
    }

    @Test("changes(startDate:endDate:page:) dropping one parameter")
    func changesStartDateDroppingOneForwardsTheRest() async throws {
        _ = try await service.changes(
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.changesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.changes(endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.changesCalls.count == 3)
    }

    @Test("changes(startDate:endDate:page:) dropping two parameters")
    func changesStartDateDroppingTwoForwardsTheRest() async throws {
        _ = try await service.changes(startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.changesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.changes(endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.changesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.changesCalls.count == 3)
    }

    @Test("changes(startDate:endDate:page:) dropping three parameters")
    func changesStartDateDroppingThreeForwardsTheRest() async throws {
        _ = try await service.changes()
        let call = try #require(service.changesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.changesCalls.count == 1)
    }

    @Test("popular(page:language:) conveniences forward the parameters they omit")
    func popularOverloadsForwardOmittedParameters() async throws {
        _ = try await service.popular(page: 3)
        var call = try #require(service.popularCalls.last)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.popular(language: "en-GB")
        call = try #require(service.popularCalls.last)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.popular()
        call = try #require(service.popularCalls.last)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.popularCalls.count == 3)
    }

}
