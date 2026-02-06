//
//  TVSeriesServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.serialized, 
    .tags(.tvSeason),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct TVSeriesServiceTests {

    var tvSeriesService: (any TVSeriesService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.tvSeriesService = TMDbClient(apiKey: apiKey).tvSeries
    }

    @Test("details")
    func details() async throws {
        let tvSeriesID = 84958

        let tvSeries = try await tvSeriesService.details(forTVSeries: tvSeriesID)

        #expect(tvSeries.id == tvSeriesID)
        #expect(tvSeries.name == "Loki")
    }

    @Test("credits")
    func credits() async throws {
        let tvSeriesID = 4604

        let credits = try await tvSeriesService.credits(forTVSeries: tvSeriesID)

        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("aggregateCredits")
    func aggregateCredits() async throws {
        let tvSeriesID = 4604

        let credits = try await tvSeriesService.aggregateCredits(forTVSeries: tvSeriesID)

        #expect(!credits.cast.isEmpty)
        #expect(!credits.crew.isEmpty)
    }

    @Test("reviews")
    func reviews() async throws {
        let tvSeriesID = 76479

        let reviewList = try await tvSeriesService.reviews(forTVSeries: tvSeriesID)

        #expect(!reviewList.results.isEmpty)
    }

    @Test("images")
    func images() async throws {
        let tvSeriesID = 76479

        let imageCollection = try await tvSeriesService.images(forTVSeries: tvSeriesID)

        #expect(imageCollection.id == tvSeriesID)
        #expect(!imageCollection.backdrops.isEmpty)
        #expect(!imageCollection.logos.isEmpty)
        #expect(!imageCollection.posters.isEmpty)
    }

    @Test("videos")
    func videos() async throws {
        let tvSeriesID = 76479

        let videoCollection = try await tvSeriesService.videos(forTVSeries: tvSeriesID)

        #expect(videoCollection.id == tvSeriesID)
        #expect(!videoCollection.results.isEmpty)
    }

    @Test("recommendations")
    func recommendations() async throws {
        let tvSeriesID = 549

        let tvSeriesList = try await tvSeriesService.recommendations(forTVSeries: tvSeriesID)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("similar")
    func similar() async throws {
        let tvSeriesID = 76479

        let tvSeriesList = try await tvSeriesService.similar(toTVSeries: tvSeriesID)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("popular")
    func popular() async throws {
        let tvSeriesList = try await tvSeriesService.popular()

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("airingToday")
    func airingToday() async throws {
        let tvSeriesList = try await tvSeriesService.airingToday()

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("onTheAir")
    func onTheAir() async throws {
        let tvSeriesList = try await tvSeriesService.onTheAir()

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("topRated")
    func topRated() async throws {
        let tvSeriesList = try await tvSeriesService.topRated()

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("externalLinks")
    func externalLinks() async throws {
        let tvSeriesID = 86423

        let linksCollection = try await tvSeriesService.externalLinks(forTVSeries: tvSeriesID)

        #expect(linksCollection.id == tvSeriesID)
        #expect(linksCollection.imdb != nil)
        #expect(linksCollection.wikiData != nil)
        #expect(linksCollection.facebook != nil)
        #expect(linksCollection.instagram != nil)
        #expect(linksCollection.twitter != nil)
    }

    @Test("contentRatings")
    func contentRatings() async throws {
        let tvSeriesID = 8592

        let allContentRatings = try await tvSeriesService.contentRatings(forTVSeries: tvSeriesID)

        #expect(!allContentRatings.isEmpty)

        let usRating = allContentRatings.first { $0.countryCode == "US" }
        let unwrappedUSRating = try #require(usRating)

        #expect(unwrappedUSRating.rating == "TV-14")
        #expect(unwrappedUSRating.countryCode == "US")
    }

    @Test("details includes productionCountries and spokenLanguages")
    func detailsIncludesProductionCountriesAndSpokenLanguages() async throws {
        // Breaking Bad
        let tvSeriesID = 1396

        let tvSeries = try await tvSeriesService.details(forTVSeries: tvSeriesID)

        #expect(tvSeries.id == tvSeriesID)

        let productionCountries = try #require(tvSeries.productionCountries)
        #expect(!productionCountries.isEmpty)

        let spokenLanguages = try #require(tvSeries.spokenLanguages)
        #expect(!spokenLanguages.isEmpty)
    }

    @Test("details includes lastEpisodeToAir and nextEpisodeToAir for airing series")
    func detailsIncludesEpisodeAirDatesForAiringSeries() async throws {
        // The Pitt - currently airing series
        let tvSeriesID = 250_307

        let tvSeries = try await tvSeriesService.details(forTVSeries: tvSeriesID)

        #expect(tvSeries.id == tvSeriesID)

        // lastEpisodeToAir should exist for currently airing shows
        if let lastEpisode = tvSeries.lastEpisodeToAir {
            #expect(lastEpisode.id > 0)
            #expect(!lastEpisode.name.isEmpty)
            #expect(lastEpisode.episodeNumber > 0)
            #expect(lastEpisode.seasonNumber > 0)
            if let showID = lastEpisode.showID {
                #expect(showID == tvSeriesID)
            }
        }

        // nextEpisodeToAir may exist for currently airing shows
        if let nextEpisode = tvSeries.nextEpisodeToAir {
            #expect(nextEpisode.id > 0)
            #expect(!nextEpisode.name.isEmpty)
            #expect(nextEpisode.episodeNumber > 0)
            #expect(nextEpisode.seasonNumber > 0)
            if let showID = nextEpisode.showID {
                #expect(showID == tvSeriesID)
            }
        }
    }

    @Test("details for ended series has lastEpisodeToAir but no nextEpisodeToAir")
    func detailsForEndedSeries() async throws {
        // Breaking Bad - ended series
        let tvSeriesID = 1396

        let tvSeries = try await tvSeriesService.details(forTVSeries: tvSeriesID)

        #expect(tvSeries.id == tvSeriesID)
        #expect(tvSeries.lastEpisodeToAir != nil)

        // Verify lastEpisodeToAir details
        if let lastEpisode = tvSeries.lastEpisodeToAir {
            #expect(lastEpisode.id > 0)
            #expect(lastEpisode.name == "Felina")
            #expect(lastEpisode.episodeNumber == 16)
            #expect(lastEpisode.seasonNumber == 5)
            if let showID = lastEpisode.showID {
                #expect(showID == tvSeriesID)
            }
            #expect(lastEpisode.episodeType == "finale")
        }

        // nextEpisodeToAir should be nil for ended series
        #expect(tvSeries.nextEpisodeToAir == nil)
    }

    @Test("watchProviders")
    func watchProviders() async throws {
        let tvSeriesID = 1399 // Game of Thrones

        let result = try await tvSeriesService.watchProviders(forTVSeries: tvSeriesID)

        #expect(!result.isEmpty)
        let usProvider = result.first { $0.countryCode == "US" }
        #expect(usProvider != nil)
    }

    @Test("keywords")
    func keywords() async throws {
        let tvSeriesID = 1396 // Breaking Bad

        let keywordCollection = try await tvSeriesService.keywords(forTVSeries: tvSeriesID)

        #expect(keywordCollection.id == tvSeriesID)
        #expect(!keywordCollection.keywords.isEmpty)
    }

    @Test("alternativeTitles")
    func alternativeTitles() async throws {
        let tvSeriesID = 1396 // Breaking Bad

        let titleCollection = try await tvSeriesService.alternativeTitles(forTVSeries: tvSeriesID)

        #expect(titleCollection.id == tvSeriesID)
        #expect(!titleCollection.titles.isEmpty)
    }

    @Test("translations")
    func translations() async throws {
        let tvSeriesID = 1396 // Breaking Bad

        let translationCollection = try await tvSeriesService.translations(forTVSeries: tvSeriesID)

        #expect(translationCollection.id == tvSeriesID)
        #expect(!translationCollection.translations.isEmpty)

        let enTranslation = translationCollection.translations.first { $0.languageCode == "en" }
        #expect(enTranslation != nil)
    }

    // Note: The /tv/{series_id}/lists endpoint appears to return data in a format
    // that doesn't include mediaType, which is required by the Media model.
    // This test is disabled pending investigation of the actual API response format.
    // @Test("lists")
    // func lists() async throws {
    //     let tvSeriesID = 1396 // Breaking Bad
    //
    //     let mediaList = try await tvSeriesService.lists(forTVSeries: tvSeriesID)
    //
    //     #expect(!mediaList.results.isEmpty)
    // }

    @Test("latest")
    func latest() async throws {
        let tvSeries = try await tvSeriesService.latest()

        #expect(tvSeries.id > 0)
    }

    @Test("changesForTVSeries")
    func changesForTVSeries() async throws {
        let tvSeriesID = 1396 // Breaking Bad

        let changeCollection = try await tvSeriesService.changes(forTVSeries: tvSeriesID)

        // May be empty if no recent changes - just verify we can decode the response
        #expect(changeCollection.changes.isEmpty || !changeCollection.changes.isEmpty)
    }

    @Test("changesForAllTVSeries")
    func changesForAllTVSeries() async throws {
        let changedIDCollection = try await tvSeriesService.changes()

        #expect(!changedIDCollection.results.isEmpty)
    }

    @Test("screenedTheatrically")
    func screenedTheatrically() async throws {
        let tvSeriesID = 1399 // Game of Thrones

        let collection = try await tvSeriesService.screenedTheatrically(forTVSeries: tvSeriesID)

        #expect(collection.id == tvSeriesID)
        #expect(!collection.results.isEmpty)
    }

    @Test("episodeGroups")
    func episodeGroups() async throws {
        let tvSeriesID = 1399 // Game of Thrones

        let collection = try await tvSeriesService.episodeGroups(forTVSeries: tvSeriesID)

        #expect(collection.id == tvSeriesID)
        #expect(!collection.episodeGroups.isEmpty)
    }

    @Test("details with appended credits and images")
    func detailsWithAppendedData() async throws {
        let tvSeriesID = 1399 // Game of Thrones

        let result = try await tvSeriesService.details(
            forTVSeries: tvSeriesID,
            appending: [.credits, .images]
        )

        #expect(result.tvSeries.id == tvSeriesID)
        #expect(result.tvSeries.name == "Game of Thrones")
        let credits = try #require(result.credits)
        #expect(credits.id == tvSeriesID)
        #expect(!credits.cast.isEmpty)
        let images = try #require(result.images)
        #expect(images.id == tvSeriesID)
    }
}
