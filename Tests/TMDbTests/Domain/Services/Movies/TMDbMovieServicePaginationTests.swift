//
//  TMDbMovieServicePaginationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServicePaginationTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    // MARK: - allPopular

    @Test("allPopular yields items from multiple pages")
    func allPopularYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, results: .mocks, totalPages: 2)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, results: .mocks, totalPages: 2)))

        var items: [MovieListItem] = []
        for try await item in service.allPopular() {
            items.append(item)
        }

        #expect(items.count == 8) // 4 per page × 2 pages
        #expect(apiClient.requests.count == 2)
    }

    @Test("allPopular with country and language makes request")
    func allPopularWithCountryAndLanguageMakesRequest() async throws {
        let country = "US"
        let language = "en"
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var items: [MovieListItem] = []
        for try await item in service.allPopular(country: country, language: language) {
            items.append(item)
        }

        #expect(apiClient.lastRequest is PopularMoviesRequest)
        #expect(items.count == 4)
    }

    @Test("allPopularPages yields page objects")
    func allPopularPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, totalPages: 2)))

        var pages: [MoviePageableList] = []
        for try await page in service.allPopularPages() {
            pages.append(page)
        }

        #expect(pages.count == 2)
        let firstPage = try #require(pages.first)
        #expect(firstPage.page == 1)
        #expect(firstPage.totalPages == 2)
    }

    // MARK: - allTopRated

    @Test("allTopRated yields items from multiple pages")
    func allTopRatedYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, totalPages: 2)))

        var items: [MovieListItem] = []
        for try await item in service.allTopRated() {
            items.append(item)
        }

        #expect(items.count == 8)
        #expect(apiClient.requests.count == 2)
    }

    @Test("allTopRatedPages yields page objects")
    func allTopRatedPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allTopRatedPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allNowPlaying

    @Test("allNowPlaying yields items from multiple pages")
    func allNowPlayingYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, totalPages: 2)))

        var items: [MovieListItem] = []
        for try await item in service.allNowPlaying() {
            items.append(item)
        }

        #expect(items.count == 8)
    }

    @Test("allNowPlayingPages yields page objects")
    func allNowPlayingPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allNowPlayingPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allUpcoming

    @Test("allUpcoming yields items from multiple pages")
    func allUpcomingYieldsItemsFromMultiplePages() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, totalPages: 2)))

        var items: [MovieListItem] = []
        for try await item in service.allUpcoming() {
            items.append(item)
        }

        #expect(items.count == 8)
    }

    @Test("allUpcomingPages yields page objects")
    func allUpcomingPagesYieldsPageObjects() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allUpcomingPages() {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allRecommendations

    @Test("allRecommendations yields items from multiple pages")
    func allRecommendationsYieldsItemsFromMultiplePages() async throws {
        let movieID = 550
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, totalPages: 2)))

        var items: [MovieListItem] = []
        for try await item in service.allRecommendations(forMovie: movieID) {
            items.append(item)
        }

        #expect(items.count == 8)
    }

    @Test("allRecommendationsPages yields page objects")
    func allRecommendationsPagesYieldsPageObjects() async throws {
        let movieID = 550
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allRecommendationsPages(forMovie: movieID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allSimilar

    @Test("allSimilar yields items from multiple pages")
    func allSimilarYieldsItemsFromMultiplePages() async throws {
        let movieID = 550
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, totalPages: 2)))

        var items: [MovieListItem] = []
        for try await item in service.allSimilar(toMovie: movieID) {
            items.append(item)
        }

        #expect(items.count == 8)
    }

    @Test("allSimilarPages yields page objects")
    func allSimilarPagesYieldsPageObjects() async throws {
        let movieID = 550
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages: [MoviePageableList] = []
        for try await page in service.allSimilarPages(toMovie: movieID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allReviews

    @Test("allReviews yields items from multiple pages")
    func allReviewsYieldsItemsFromMultiplePages() async throws {
        let movieID = 550
        apiClient.addResponse(.success(ReviewPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(ReviewPageableList.mock(page: 2, totalPages: 2)))

        var items: [Review] = []
        for try await item in service.allReviews(forMovie: movieID) {
            items.append(item)
        }

        #expect(items.count == 6) // 3 per page × 2 pages
    }

    @Test("allReviewsPages yields page objects")
    func allReviewsPagesYieldsPageObjects() async throws {
        let movieID = 550
        apiClient.addResponse(.success(ReviewPageableList.mock(page: 1, totalPages: 1)))

        var pages: [ReviewPageableList] = []
        for try await page in service.allReviewsPages(forMovie: movieID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - allLists

    @Test("allLists yields items from multiple pages")
    func allListsYieldsItemsFromMultiplePages() async throws {
        let movieID = 550
        apiClient.addResponse(.success(MediaListSummaryPageableList.mock(page: 1, totalPages: 2)))
        apiClient.addResponse(.success(MediaListSummaryPageableList.mock(page: 2, totalPages: 2)))

        var items: [MediaListSummary] = []
        for try await item in service.allLists(forMovie: movieID) {
            items.append(item)
        }

        #expect(items.count == 6) // 3 per page × 2 pages
    }

    @Test("allListsPages yields page objects")
    func allListsPagesYieldsPageObjects() async throws {
        let movieID = 550
        apiClient.addResponse(.success(MediaListSummaryPageableList.mock(page: 1, totalPages: 1)))

        var pages: [MediaListSummaryPageableList] = []
        for try await page in service.allListsPages(forMovie: movieID) {
            pages.append(page)
        }

        #expect(pages.count == 1)
    }

    // MARK: - Early Break

    @Test("allPopular stops fetching when loop breaks")
    func allPopularStopsFetchingWhenLoopBreaks() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 5)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 2, totalPages: 5)))
        apiClient.addResponse(.success(MoviePageableList.mock(page: 3, totalPages: 5)))

        var items: [MovieListItem] = []
        for try await item in service.allPopular() {
            items.append(item)
            if items.count >= 5 { // Break after ~2 pages
                break
            }
        }

        #expect(items.count == 5)
        #expect(apiClient.requests.count <= 3) // At most 3 pages fetched
    }

}
