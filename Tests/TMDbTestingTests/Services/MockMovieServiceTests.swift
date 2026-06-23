//
//  MockMovieServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

@Suite(.tags(.testingSupport, .mocks, .movie))
struct MockMovieServiceTests {

    var service: MockMovieService

    init() {
        self.service = MockMovieService()
    }

    // MARK: - details

    @Test("details by default returns the sample movie")
    func detailsByDefaultReturnsSampleMovie() async throws {
        let result = try await service.details(forMovie: 1, language: nil)

        #expect(result == Movie.sample)
    }

    @Test("details records the call with its arguments")
    func detailsRecordsCall() async throws {
        _ = try await service.details(forMovie: 42, language: "en")

        #expect(service.detailsCalls.count == 1)
        let call = try #require(service.detailsCalls.first)
        #expect(call.movieID == 42)
        #expect(call.language == "en")
    }

    @Test("details throws the injected failure")
    func detailsThrowsInjectedFailure() async {
        service.detailsResult = .failure(.unknown)

        await #expect(throws: TMDbError.unknown) {
            try await service.details(forMovie: 1, language: nil)
        }
    }

    @Test("details returns the injected success value")
    func detailsReturnsInjectedSuccess() async throws {
        let injected = Movie(id: 99, title: "Custom Movie")
        service.detailsResult = .success(injected)

        let result = try await service.details(forMovie: 1, language: nil)

        #expect(result == injected)
    }

    // MARK: - nowPlaying (pageable)

    @Test("nowPlaying by default returns the sample pageable list")
    func nowPlayingByDefaultReturnsSampleList() async throws {
        let result = try await service.nowPlaying(page: nil, country: nil, language: nil)

        #expect(result == MoviePageableList.sample)
    }

    @Test("nowPlaying records the call with its arguments")
    func nowPlayingRecordsCall() async throws {
        _ = try await service.nowPlaying(page: 3, country: "US", language: "en")

        #expect(service.nowPlayingCalls.count == 1)
        let call = try #require(service.nowPlayingCalls.first)
        #expect(call.page == 3)
        #expect(call.country == "US")
        #expect(call.language == "en")
    }

    @Test("nowPlaying throws the injected failure")
    func nowPlayingThrowsInjectedFailure() async {
        service.nowPlayingResult = .failure(.unknown)

        await #expect(throws: TMDbError.unknown) {
            try await service.nowPlaying(page: nil, country: nil, language: nil)
        }
    }

    @Test("nowPlaying returns the injected success value")
    func nowPlayingReturnsInjectedSuccess() async throws {
        let injected = MoviePageableList(
            page: 2,
            results: [
                MovieListItem(
                    id: 7,
                    title: "Paged Movie",
                    originalTitle: "Paged Movie",
                    originalLanguage: "en",
                    overview: "Paged overview.",
                    genreIDs: [28]
                )
            ],
            totalResults: 1,
            totalPages: 1
        )
        service.nowPlayingResult = .success(injected)

        let result = try await service.nowPlaying(page: nil, country: nil, language: nil)

        #expect(result == injected)
    }

    // MARK: - addRating (Void)

    @Test("addRating by default succeeds and records the call")
    func addRatingByDefaultSucceeds() async throws {
        let session = Session(success: true, sessionID: "abc")

        try await service.addRating(8.5, toMovie: 12, session: session)

        #expect(service.addRatingCalls.count == 1)
        let call = try #require(service.addRatingCalls.first)
        #expect(call.rating == 8.5)
        #expect(call.movieID == 12)
        #expect(call.session == session)
    }

    @Test("addRating throws the injected failure")
    func addRatingThrowsInjectedFailure() async {
        service.addRatingResult = .failure(.unknown)
        let session = Session(success: true, sessionID: "abc")

        await #expect(throws: TMDbError.unknown) {
            try await service.addRating(8.5, toMovie: 12, session: session)
        }
    }

    // MARK: - latest

    @Test("latest by default returns the sample movie and records the call")
    func latestByDefaultReturnsSampleMovie() async throws {
        let result = try await service.latest()

        #expect(result == Movie.sample)
        #expect(service.latestCalls.count == 1)
    }

    @Test("latest throws the injected failure")
    func latestThrowsInjectedFailure() async {
        service.latestResult = .failure(.unknown)

        await #expect(throws: TMDbError.unknown) {
            try await service.latest()
        }
    }

    @Test("latest returns the injected success value")
    func latestReturnsInjectedSuccess() async throws {
        let injected = Movie(id: 314, title: "Latest Custom")
        service.latestResult = .success(injected)

        let result = try await service.latest()

        #expect(result == injected)
    }

}
