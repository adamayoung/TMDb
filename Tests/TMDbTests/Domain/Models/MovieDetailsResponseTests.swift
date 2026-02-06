//
//  MovieDetailsResponseTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct MovieDetailsResponseTests {

    @Test(
        "JSON decoding of MovieDetailsResponse with credits and images",
        .tags(.decoding)
    )
    func decodeMovieDetailsResponseCreditsAndImages() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieDetailsResponse.self,
            fromResource: "movie-details-append-response"
        )

        #expect(result.movie.id == 550)
        #expect(result.movie.title == "Fight Club")

        let credits = try #require(result.credits)
        #expect(credits.id == 550)
        #expect(!credits.cast.isEmpty)
        #expect(credits.cast[0].id == 819)
        #expect(credits.cast[0].name == "Edward Norton")
        #expect(credits.cast[0].character == "The Narrator")
        #expect(!credits.crew.isEmpty)
        #expect(credits.crew[0].id == 7467)
        #expect(credits.crew[0].name == "David Fincher")
        #expect(credits.crew[0].job == "Director")

        let images = try #require(result.images)
        #expect(images.id == 550)
        #expect(!images.backdrops.isEmpty)
        #expect(!images.posters.isEmpty)
        #expect(images.logos.isEmpty)

        let keywords = try #require(result.keywords)
        #expect(keywords.count == 2)
        #expect(keywords[0].id == 851)
        #expect(keywords[0].name == "dual identity")
        #expect(keywords[1].id == 818)

        let externalIDs = try #require(result.externalIDs)
        #expect(externalIDs.id == 550)
        #expect(externalIDs.imdb != nil)
        #expect(externalIDs.imdb?.id == "tt0137523")
        #expect(externalIDs.wikiData != nil)
        #expect(externalIDs.facebook != nil)
    }

    @Test(
        "JSON decoding of MovieDetailsResponse with all appended data",
        .tags(.decoding)
    )
    func decodeMovieDetailsResponseAllAppendedData() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieDetailsResponse.self,
            fromResource: "movie-details-append-response"
        )

        let videos = try #require(result.videos)
        #expect(videos.id == 550)
        #expect(!videos.results.isEmpty)
        #expect(videos.results[0].id == "533ec654c3a36854480003eb")
        #expect(videos.results[0].name == "Trailer")
        #expect(videos.results[0].site == "YouTube")
        #expect(videos.results[0].key == "SUXWAEX2jlg")
        #expect(videos.results[0].type == .trailer)
        #expect(videos.results[0].size == .s720)

        let reviews = try #require(result.reviews)
        #expect(!reviews.results.isEmpty)
        #expect(reviews.results[0].id == "58a23e01c3a3687f72003c30")
        #expect(reviews.results[0].author == "Cat Ellington")

        let recommendations = try #require(result.recommendations)
        #expect(!recommendations.results.isEmpty)
        #expect(recommendations.results[0].id == 680)
        #expect(recommendations.results[0].title == "Pulp Fiction")

        let similar = try #require(result.similar)
        #expect(!similar.results.isEmpty)
        #expect(similar.results[0].id == 807)
        #expect(similar.results[0].title == "Se7en")

        let releaseDates = try #require(result.releaseDates)
        #expect(!releaseDates.isEmpty)
        #expect(releaseDates[0].countryCode == "US")
        #expect(releaseDates[0].releaseDates[0].certification == "R")
        #expect(releaseDates[0].releaseDates[0].type == .theatrical)

        let altTitles = try #require(result.alternativeTitles)
        #expect(!altTitles.isEmpty)
        #expect(altTitles[0].countryCode == "DE")

        let translations = try #require(result.translations)
        #expect(!translations.isEmpty)
        #expect(translations[0].countryCode == "DE")
        #expect(translations[0].data.title == "Fight Club")

        let watchProviders = try #require(result.watchProviders)
        let usProvider = try #require(watchProviders["US"])
        let flatRate = try #require(usProvider.flatRate)
        #expect(flatRate[0].id == 8)
        #expect(flatRate[0].name == "Netflix")

        let lists = try #require(result.lists)
        #expect(!lists.results.isEmpty)
        #expect(lists.results[0].id == 1)

        let changes = try #require(result.changes)
        #expect(!changes.changes.isEmpty)
        #expect(changes.changes[0].key == "overview")
    }

    @Test(
        "JSON decoding of MovieDetailsResponse without appended data",
        .tags(.decoding)
    )
    func decodeMovieDetailsResponseWithoutAppendedData() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieDetailsResponse.self,
            fromResource: "movie"
        )

        #expect(result.movie.id == 550)
        #expect(result.movie.title == "Fight Club")
        #expect(result.credits == nil)
        #expect(result.images == nil)
        #expect(result.videos == nil)
        #expect(result.reviews == nil)
        #expect(result.recommendations == nil)
        #expect(result.similar == nil)
        #expect(result.releaseDates == nil)
        #expect(result.alternativeTitles == nil)
        #expect(result.translations == nil)
        #expect(result.keywords == nil)
        #expect(result.watchProviders == nil)
        #expect(result.externalIDs == nil)
        #expect(result.lists == nil)
        #expect(result.changes == nil)
    }

}
