//
//  TMDbGuestSessionServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .guestSession))
struct TMDbGuestSessionServicePaginationTests {

    var service: TMDbGuestSessionService!
    var apiClient: MockAPIClient!

    let guestSessionID = "abc123"

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbGuestSessionService(apiClient: apiClient)
    }

    // MARK: - allRatedMovies

    @Test("allRatedMovies yields items from multiple pages")
    func allRatedMoviesYieldsItemsFromMultiplePages() async throws {
        let page1 = MoviePageableList.mock(page: 1, totalPages: 2)
        let page2 = MoviePageableList.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [MovieListItem] = []
        for try await item in service.allRatedMovies(guestSessionID: guestSessionID) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.requests.count == 2)
        #expect(apiClient.lastRequest is GuestSessionRatedMoviesRequest)
    }

    @Test("allRatedMoviesPages yields page objects")
    func allRatedMoviesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allRatedMoviesPages(guestSessionID: guestSessionID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allRatedTVSeries

    @Test("allRatedTVSeries yields items from multiple pages")
    func allRatedTVSeriesYieldsItemsFromMultiplePages() async throws {
        let page1 = TVSeriesPageableList.mock(page: 1, totalPages: 2)
        let page2 = TVSeriesPageableList.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [TVSeriesListItem] = []
        for try await item in service.allRatedTVSeries(guestSessionID: guestSessionID) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.requests.count == 2)
        #expect(apiClient.lastRequest is GuestSessionRatedTVSeriesRequest)
    }

    @Test("allRatedTVSeriesPages yields page objects")
    func allRatedTVSeriesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allRatedTVSeriesPages(guestSessionID: guestSessionID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allRatedTVEpisodes

    @Test("allRatedTVEpisodes yields items from multiple pages")
    func allRatedTVEpisodesYieldsItemsFromMultiplePages() async throws {
        let page1 = TVEpisodePageableList.mock(page: 1, totalPages: 2)
        let page2 = TVEpisodePageableList.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [TVEpisode] = []
        for try await item in service.allRatedTVEpisodes(guestSessionID: guestSessionID) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.requests.count == 2)
        #expect(apiClient.lastRequest is GuestSessionRatedTVEpisodesRequest)
    }

    @Test("allRatedTVEpisodesPages yields page objects")
    func allRatedTVEpisodesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVEpisodePageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVEpisodePageableList] = []
        for try await page in service.allRatedTVEpisodesPages(guestSessionID: guestSessionID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

}
