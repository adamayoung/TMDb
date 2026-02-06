//
//  SearchPaginationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .tags(.search),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct SearchPaginationIntegrationTests {

    var client: TMDbClient!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.client = TMDbClient(apiKey: apiKey)
    }

    @Test("search allMovies fetches items from live API")
    func searchAllMoviesFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.search.allMovies(query: "Matrix") {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("search allMulti fetches items from live API")
    func searchAllMultiFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.search.allMulti(query: "Star Wars") {
            itemCount += 1
            if itemCount >= 25 {
                break
            }
        }
        #expect(itemCount >= 20)
    }

    @Test("search allMoviesPages yields page objects from live API")
    func searchAllMoviesPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.search.allMoviesPages(query: "Spider") {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

    @Test("search allTVSeries fetches items from live API")
    func searchAllTVSeriesFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.search.allTVSeries(query: "Breaking Bad") {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 5)
    }

    @Test("search allTVSeriesPages yields page objects from live API")
    func searchAllTVSeriesPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.search.allTVSeriesPages(query: "Star Trek") {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("search allPeople fetches items from live API")
    func searchAllPeopleFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.search.allPeople(query: "Tom Hanks") {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 1)
    }

    @Test("search allPeoplePages yields page objects from live API")
    func searchAllPeoplePagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.search.allPeoplePages(query: "Smith") {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("search allCollections fetches items from live API")
    func searchAllCollectionsFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.search.allCollections(query: "Lord of the Rings") {
            itemCount += 1
            if itemCount >= 5 {
                break
            }
        }
        #expect(itemCount >= 1)
    }

    @Test("search allCollectionsPages yields page objects from live API")
    func searchAllCollectionsPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.search.allCollectionsPages(query: "Marvel") {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 1 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("search allCompanies fetches items from live API")
    func searchAllCompaniesFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.search.allCompanies(query: "Universal") {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 5)
    }

    @Test("search allCompaniesPages yields page objects from live API")
    func searchAllCompaniesPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.search.allCompaniesPages(query: "Studio") {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 1 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("search allKeywords fetches items from live API")
    func searchAllKeywordsFetchesItemsFromLiveAPI() async throws {
        var itemCount = 0
        for try await _ in client.search.allKeywords(query: "alien") {
            itemCount += 1
            if itemCount >= 10 {
                break
            }
        }
        #expect(itemCount >= 5)
    }

    @Test("search allKeywordsPages yields page objects from live API")
    func searchAllKeywordsPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.search.allKeywordsPages(query: "love") {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 1 {
                break
            }
        }
        #expect(pageCount >= 1)
    }

    @Test("search allMultiPages yields page objects from live API")
    func searchAllMultiPagesYieldsPageObjectsFromLiveAPI() async throws {
        var pageCount = 0
        for try await page in client.search.allMultiPages(query: "Avengers") {
            pageCount += 1
            #expect(!page.results.isEmpty)
            if pageCount >= 2 {
                break
            }
        }
        #expect(pageCount == 2)
    }

}
