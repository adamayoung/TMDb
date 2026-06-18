//
//  TMDbAccountServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .account))
struct TMDbAccountServicePaginationTests {

    var service: TMDbAccountService!
    var apiClient: MockAPIClient!

    let accountID = 11
    let session = Session.mock()

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbAccountService(apiClient: apiClient)
    }

    // MARK: - allFavouriteMovies

    @Test("allFavouriteMovies yields items from multiple pages")
    func allFavouriteMoviesYieldsItemsFromMultiplePages() async throws {
        let page1 = MoviePageableList.mock(page: 1, totalPages: 2)
        let page2 = MoviePageableList.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [MovieListItem] = []
        for try await item in service.allFavouriteMovies(accountID: accountID, session: session) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.requests.count == 2)
        #expect(apiClient.lastRequest is FavouriteMoviesRequest)
    }

    @Test("allFavouriteMoviesPages yields page objects")
    func allFavouriteMoviesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allFavouriteMoviesPages(accountID: accountID, session: session) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allFavouriteTVSeries

    @Test("allFavouriteTVSeries yields items from multiple pages")
    func allFavouriteTVSeriesYieldsItemsFromMultiplePages() async throws {
        let page1 = TVSeriesPageableList.mock(page: 1, totalPages: 2)
        let page2 = TVSeriesPageableList.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [TVSeriesListItem] = []
        for try await item in service.allFavouriteTVSeries(accountID: accountID, session: session) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.lastRequest is FavouriteTVSeriesRequest)
    }

    @Test("allFavouriteTVSeriesPages yields page objects")
    func allFavouriteTVSeriesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allFavouriteTVSeriesPages(accountID: accountID, session: session) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allWatchlistMovies

    @Test("allWatchlistMovies yields items from multiple pages")
    func allWatchlistMoviesYieldsItemsFromMultiplePages() async throws {
        let page1 = MoviePageableList.mock(page: 1, totalPages: 2)
        let page2 = MoviePageableList.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [MovieListItem] = []
        for try await item in service.allWatchlistMovies(accountID: accountID, session: session) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.lastRequest is MovieWatchlistRequest)
    }

    @Test("allWatchlistMoviesPages yields page objects")
    func allWatchlistMoviesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allWatchlistMoviesPages(accountID: accountID, session: session) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allWatchlistTVSeries

    @Test("allWatchlistTVSeries yields items from multiple pages")
    func allWatchlistTVSeriesYieldsItemsFromMultiplePages() async throws {
        let page1 = TVSeriesPageableList.mock(page: 1, totalPages: 2)
        let page2 = TVSeriesPageableList.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [TVSeriesListItem] = []
        for try await item in service.allWatchlistTVSeries(accountID: accountID, session: session) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.lastRequest is TVSeriesWatchlistRequest)
    }

    @Test("allWatchlistTVSeriesPages yields page objects")
    func allWatchlistTVSeriesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allWatchlistTVSeriesPages(accountID: accountID, session: session) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allRatedMovies

    @Test("allRatedMovies yields items from multiple pages")
    func allRatedMoviesYieldsItemsFromMultiplePages() async throws {
        let page1 = MoviePageableList.mock(page: 1, totalPages: 2)
        let page2 = MoviePageableList.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [MovieListItem] = []
        for try await item in service.allRatedMovies(accountID: accountID, session: session) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.lastRequest is RatedMoviesRequest)
    }

    @Test("allRatedMoviesPages yields page objects")
    func allRatedMoviesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allRatedMoviesPages(accountID: accountID, session: session) {
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
        for try await item in service.allRatedTVSeries(accountID: accountID, session: session) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.lastRequest is RatedTVSeriesRequest)
    }

    @Test("allRatedTVSeriesPages yields page objects")
    func allRatedTVSeriesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVSeriesPageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVSeriesPageableList] = []
        for try await page in service.allRatedTVSeriesPages(accountID: accountID, session: session) {
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
        for try await item in service.allRatedTVEpisodes(accountID: accountID, session: session) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.lastRequest is RatedTVEpisodesRequest)
    }

    @Test("allRatedTVEpisodesPages yields page objects")
    func allRatedTVEpisodesPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(TVEpisodePageableList.mock(page: 1, totalPages: 1)))

        var pages: [TVEpisodePageableList] = []
        for try await page in service.allRatedTVEpisodesPages(accountID: accountID, session: session) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allLists

    @Test("allLists yields items from multiple pages")
    func allListsYieldsItemsFromMultiplePages() async throws {
        let page1 = MediaListSummaryPageableList.mock(page: 1, totalPages: 2)
        let page2 = MediaListSummaryPageableList.mock(page: 2, totalPages: 2)
        apiClient.addResponse(.success(page1))
        apiClient.addResponse(.success(page2))

        var items: [MediaListSummary] = []
        for try await item in service.allLists(accountID: accountID, session: session) {
            items.append(item)
        }

        #expect(items.count == page1.results.count + page2.results.count)
        #expect(apiClient.lastRequest is AccountListsRequest)
    }

    @Test("allListsPages yields page objects")
    func allListsPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MediaListSummaryPageableList.mock(page: 1, totalPages: 1)))

        var pages: [MediaListSummaryPageableList] = []
        for try await page in service.allListsPages(accountID: accountID, session: session) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

}
