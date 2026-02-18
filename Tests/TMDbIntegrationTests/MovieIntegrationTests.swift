//
//  MovieIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .serialized,
    .tags(.movie),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct MovieIntegrationTests {

    var movieService: (any MovieService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.movieService = TMDbClient(apiKey: apiKey).movies
    }

    @Test("details")
    func details() async throws {
        let movieID = 346_698

        let movie = try await movieService.details(forMovie: movieID)

        #expect(movie.id == movieID)
        #expect(movie.title == "Barbie")
    }

    @Test("details includes originCountry")
    func detailsIncludesOriginCountry() async throws {
        let movieID = 346_698

        let movie = try await movieService.details(forMovie: movieID)

        let originCountry = try #require(movie.originCountry)
        #expect(!originCountry.isEmpty)
    }

    @Test("details for movie in a collection includes belongsToCollection")
    func detailsForMovieInCollection() async throws {
        // Harry Potter and the Philosopher's Stone
        let movieID = 671

        let movie = try await movieService.details(forMovie: movieID)

        #expect(movie.id == movieID)
        let collection = try #require(movie.belongsToCollection)
        #expect(collection.id == 1241)
        #expect(collection.name == "Harry Potter Collection")
        #expect(collection.posterPath != nil)
        #expect(collection.backdropPath != nil)
    }

    @Test("credits")
    func credits() async throws {
        let movieID = 346_698

        let credits = try await movieService.credits(forMovie: movieID)

        #expect(credits.id == movieID)
        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("reviews")
    func reviews() async throws {
        let movieID = 346_698

        let reviewList = try await movieService.reviews(forMovie: movieID)

        #expect(!reviewList.results.isEmpty)
    }

    @Test("images")
    func images() async throws {
        let movieID = 346_698

        let imageCollection = try await movieService.images(forMovie: movieID)

        #expect(imageCollection.id == movieID)
        #expect(!imageCollection.posters.isEmpty)
        #expect(!imageCollection.logos.isEmpty)
        #expect(!imageCollection.backdrops.isEmpty)
    }

    @Test("videos")
    func videos() async throws {
        let movieID = 346_698

        let videoCollection = try await movieService.videos(forMovie: movieID)

        #expect(videoCollection.id == movieID)
        #expect(!videoCollection.results.isEmpty)
    }

    @Test("recommendations")
    func recommendations() async throws {
        let movieID = 921_636

        let recommendationList = try await movieService.recommendations(forMovie: movieID)

        #expect(!recommendationList.results.isEmpty)
    }

    @Test("similar")
    func similar() async throws {
        let movieID = 921_636

        let movieList = try await movieService.similar(toMovie: movieID)

        #expect(!movieList.results.isEmpty)
    }

    @Test("nowPlaying")
    func nowPlaying() async throws {
        let movieList = try await movieService.nowPlaying()

        #expect(!movieList.results.isEmpty)
    }

    @Test("popular")
    func popular() async throws {
        let movieList = try await movieService.popular()

        #expect(!movieList.results.isEmpty)
    }

    @Test("topRated")
    func topRated() async throws {
        let movieList = try await movieService.topRated()

        #expect(!movieList.results.isEmpty)
    }

    @Test("upcoming")
    func upcoming() async throws {
        let movieList = try await movieService.upcoming()

        #expect(!movieList.results.isEmpty)
    }

    @Test("externalLinks")
    func externalLinks() async throws {
        let movieID = 346_698

        let linksCollection = try await movieService.externalLinks(forMovie: movieID)

        #expect(linksCollection.id == movieID)
        #expect(linksCollection.imdb != nil)
        #expect(linksCollection.wikiData != nil)
        #expect(linksCollection.facebook != nil)
        #expect(linksCollection.instagram != nil)
        #expect(linksCollection.twitter != nil)
    }

    @Test("releaseDates")
    func releaseDates() async throws {
        let movieID = 346_698

        let releaseDatesByCountry = try await movieService.releaseDates(forMovie: movieID)

        #expect(!releaseDatesByCountry.isEmpty)
        let usReleaseDates = try #require(releaseDatesByCountry.first { $0.countryCode == "US" })
        #expect(!usReleaseDates.releaseDates.isEmpty)
    }

    @Test("watchProviders")
    func watchProviders() async throws {
        let movieID = 550 // Fight Club

        let result = try await movieService.watchProviders(forMovie: movieID)

        #expect(!result.isEmpty)
        let usProvider = result.first { $0.countryCode == "US" }
        #expect(usProvider != nil)
    }

    @Test("alternativeTitles")
    func alternativeTitles() async throws {
        let movieID = 346_698

        let alternativeTitleCollection = try await movieService.alternativeTitles(forMovie: movieID)

        #expect(alternativeTitleCollection.id == movieID)
        #expect(!alternativeTitleCollection.titles.isEmpty)
    }

    @Test("translations")
    func translations() async throws {
        let movieID = 346_698

        let translationCollection = try await movieService.translations(forMovie: movieID)

        #expect(translationCollection.id == movieID)
        #expect(!translationCollection.translations.isEmpty)
        let englishTranslation = try #require(
            translationCollection.translations.first { $0.languageCode == "en" }
        )
        // The English translation may have an empty title field in the API response
        #expect(!englishTranslation.data.overview.isEmpty)
    }

    @Test("lists")
    func lists() async throws {
        let movieID = 550 // Fight Club

        let mediaList = try await movieService.lists(forMovie: movieID)

        #expect(!mediaList.results.isEmpty)
    }

    @Test("changes for movie")
    func changesForMovie() async throws {
        let movieID = 346_698

        let changeCollection = try await movieService.changes(forMovie: movieID)

        #expect(!changeCollection.changes.isEmpty)
    }

    @Test("latest")
    func latest() async throws {
        let movie = try await movieService.latest()

        #expect(movie.id > 0)
        #expect(!movie.title.isEmpty)
    }

    @Test("changes list")
    func changesList() async throws {
        let changedIDCollection = try await movieService.changes()

        #expect(!changedIDCollection.results.isEmpty)
        #expect(changedIDCollection.page > 0)
        #expect(changedIDCollection.totalPages > 0)
        #expect(changedIDCollection.totalResults > 0)
    }

    @Test("keywords")
    func keywords() async throws {
        let movieID = 550 // Fight Club

        let keywordCollection = try await movieService.keywords(forMovie: movieID)

        #expect(keywordCollection.id == movieID)
        #expect(!keywordCollection.keywords.isEmpty)
    }

    @Test("details with appended credits and images")
    func detailsWithAppendedData() async throws {
        let movieID = 550 // Fight Club

        let result = try await movieService.details(
            forMovie: movieID,
            appending: [.credits, .images]
        )

        #expect(result.movie.id == movieID)
        #expect(result.movie.title == "Fight Club")
        let credits = try #require(result.credits)
        #expect(credits.id == movieID)
        #expect(!credits.cast.isEmpty)
        let images = try #require(result.images)
        #expect(images.id == movieID)
    }

}
