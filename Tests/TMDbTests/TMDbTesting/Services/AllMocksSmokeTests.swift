//
//  AllMocksSmokeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

@Suite(.tags(.testingSupport, .mocks))
struct AllMocksSmokeTests {

    @Test("MockAccountService is usable with zero setup")
    func accountServiceSmoke() async throws {
        let service = MockAccountService()
        _ = try await service.details(session: .sample)
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockCertificationService is usable with zero setup")
    func certificationServiceSmoke() async throws {
        let service = MockCertificationService()
        _ = try await service.movieCertifications()
        #expect(service.movieCertificationsCalls.count == 1)
    }

    @Test("MockChangesService is usable with zero setup")
    func changesServiceSmoke() async throws {
        let service = MockChangesService()
        _ = try await service.movieChanges(startDate: nil, endDate: nil, page: nil)
        #expect(service.movieChangesCalls.count == 1)
    }

    @Test("MockCollectionService is usable with zero setup")
    func collectionServiceSmoke() async throws {
        let service = MockCollectionService()
        _ = try await service.details(forCollection: 1, language: nil)
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockCompanyService is usable with zero setup")
    func companyServiceSmoke() async throws {
        let service = MockCompanyService()
        _ = try await service.details(forCompany: 1)
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockConfigurationService is usable with zero setup")
    func configurationServiceSmoke() async throws {
        let service = MockConfigurationService()
        _ = try await service.apiConfiguration()
        #expect(service.apiConfigurationCalls.count == 1)
    }

    @Test("MockCreditService is usable with zero setup")
    func creditServiceSmoke() async throws {
        let service = MockCreditService()
        _ = try await service.details(forCredit: "credit-id")
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockDiscoverService is usable with zero setup")
    func discoverServiceSmoke() async throws {
        let service = MockDiscoverService()
        _ = try await service.movies(filter: nil, sortedBy: nil, page: nil, language: nil)
        #expect(service.moviesCalls.count == 1)
    }

    @Test("MockFindService is usable with zero setup")
    func findServiceSmoke() async throws {
        let service = MockFindService()
        _ = try await service.find(externalID: "tt0111161", externalSource: .imdbID, language: nil)
        #expect(service.findCalls.count == 1)
    }

    @Test("MockGuestSessionService is usable with zero setup")
    func guestSessionServiceSmoke() async throws {
        let service = MockGuestSessionService()
        _ = try await service.ratedMovies(sortedBy: nil, page: nil, guestSessionID: "guest")
        #expect(service.ratedMoviesCalls.count == 1)
    }

    @Test("MockKeywordService is usable with zero setup")
    func keywordServiceSmoke() async throws {
        let service = MockKeywordService()
        _ = try await service.details(forKeyword: 1)
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockListService is usable with zero setup")
    func listServiceSmoke() async throws {
        let service = MockListService()
        _ = try await service.details(forList: 1, page: nil)
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockNetworkService is usable with zero setup")
    func networkServiceSmoke() async throws {
        let service = MockNetworkService()
        _ = try await service.details(forNetwork: 1)
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockPersonService is usable with zero setup")
    func personServiceSmoke() async throws {
        let service = MockPersonService()
        _ = try await service.details(forPerson: 1, language: nil)
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockReviewService is usable with zero setup")
    func reviewServiceSmoke() async throws {
        let service = MockReviewService()
        _ = try await service.details(forReview: "review-id")
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockSearchService is usable with zero setup")
    func searchServiceSmoke() async throws {
        let service = MockSearchService()
        _ = try await service.searchAll(query: "matrix", filter: nil, page: nil, language: nil)
        #expect(service.searchAllCalls.count == 1)
    }

    @Test("MockTrendingService is usable with zero setup")
    func trendingServiceSmoke() async throws {
        let service = MockTrendingService()
        _ = try await service.movies(inTimeWindow: .day, page: nil, language: nil)
        #expect(service.moviesCalls.count == 1)
    }

    @Test("MockTVEpisodeGroupService is usable with zero setup")
    func tvEpisodeGroupServiceSmoke() async throws {
        let service = MockTVEpisodeGroupService()
        _ = try await service.details(forTVEpisodeGroup: "group-id")
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockTVEpisodeService is usable with zero setup")
    func tvEpisodeServiceSmoke() async throws {
        let service = MockTVEpisodeService()
        _ = try await service.details(
            forEpisode: 1,
            inSeason: 1,
            inTVSeries: 1,
            language: nil
        )
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockTVSeasonService is usable with zero setup")
    func tvSeasonServiceSmoke() async throws {
        let service = MockTVSeasonService()
        _ = try await service.details(forSeason: 1, inTVSeries: 1, language: nil)
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockTVSeriesService is usable with zero setup")
    func tvSeriesServiceSmoke() async throws {
        let service = MockTVSeriesService()
        _ = try await service.details(forTVSeries: 1, language: nil)
        #expect(service.detailsCalls.count == 1)
    }

    @Test("MockWatchProviderService is usable with zero setup")
    func watchProviderServiceSmoke() async throws {
        let service = MockWatchProviderService()
        _ = try await service.countries(language: nil)
        #expect(service.countriesCalls.count == 1)
    }

}
