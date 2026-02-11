//
//  APIRequestQueryItemNameTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.apiClient, .domain))
struct APIRequestQueryItemNameTests {

    @Test("pageName")
    func pageQueryItemName() {
        #expect(APIRequestQueryItem.Name.page == "page")
    }

    @Test("sortBy")
    func sortByQueryItemName() {
        #expect(APIRequestQueryItem.Name.sortBy == "sort_by")
    }

    @Test("withPeople")
    func withPeopleQueryItemName() {
        #expect(APIRequestQueryItem.Name.withPeople == "with_people")
    }

    @Test("watchRegion")
    func watchRegionQueryItemName() {
        #expect(APIRequestQueryItem.Name.watchRegion == "watch_region")
    }

    @Test("includeImageLanguage")
    func includeImageLanguageQueryItemName() {
        #expect(APIRequestQueryItem.Name.includeImageLanguage == "include_image_language")
    }

    @Test("includeVideoLanguage")
    func includeVideoLanguageQueryItemName() {
        #expect(APIRequestQueryItem.Name.includeVideoLanguage == "include_video_language")
    }

    @Test("includeAdult")
    func includeAdultQueryItemName() {
        #expect(APIRequestQueryItem.Name.includeAdult == "include_adult")
    }

    @Test("query")
    func queryQueryItemName() {
        #expect(APIRequestQueryItem.Name.query == "query")
    }

    @Test("year")
    func yearQueryItemName() {
        #expect(APIRequestQueryItem.Name.year == "year")
    }

    @Test("primaryReleaseYear")
    func primaryReleaseYearQueryItemName() {
        #expect(APIRequestQueryItem.Name.primaryReleaseYear == "primary_release_year")
    }

    @Test("firstAirDateYear")
    func firstAirDateYearQueryItemName() {
        #expect(APIRequestQueryItem.Name.firstAirDateYear == "first_air_date_year")
    }

    @Test("sesionID")
    func sessionIDQueryItemName() {
        #expect(APIRequestQueryItem.Name.sessionID == "session_id")
    }

    @Test("language")
    func languageQueryItemName() {
        #expect(APIRequestQueryItem.Name.language == "language")
    }

    @Test("region")
    func regionQueryItemName() {
        #expect(APIRequestQueryItem.Name.region == "region")
    }

    @Test("withOriginalLanguage")
    func withOriginalLanguageQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.withOriginalLanguage
                == "with_original_language"
        )
    }

    @Test("withGenres")
    func withGenresQueryItemName() {
        #expect(APIRequestQueryItem.Name.withGenres == "with_genres")
    }

    @Test("withoutGenres")
    func withoutGenresQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.withoutGenres == "without_genres"
        )
    }

    @Test("withCompanies")
    func withCompaniesQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.withCompanies == "with_companies"
        )
    }

    @Test("withKeywords")
    func withKeywordsQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.withKeywords == "with_keywords"
        )
    }

    @Test("withoutKeywords")
    func withoutKeywordsQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.withoutKeywords == "without_keywords"
        )
    }

    @Test("withNetworks")
    func withNetworksQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.withNetworks == "with_networks"
        )
    }

    @Test("withWatchProviders")
    func withWatchProvidersQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.withWatchProviders
                == "with_watch_providers"
        )
    }

    @Test("withRuntimeGreaterThan")
    func withRuntimeGreaterThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.withRuntimeGreaterThan
                == "with_runtime.gte"
        )
    }

    @Test("withRuntimeLessThan")
    func withRuntimeLessThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.withRuntimeLessThan
                == "with_runtime.lte"
        )
    }

    @Test("voteAverageGreaterThan")
    func voteAverageGreaterThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.voteAverageGreaterThan
                == "vote_average.gte"
        )
    }

    @Test("voteAverageLessThan")
    func voteAverageLessThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.voteAverageLessThan
                == "vote_average.lte"
        )
    }

    @Test("voteCountGreaterThan")
    func voteCountGreaterThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.voteCountGreaterThan
                == "vote_count.gte"
        )
    }

    @Test("voteCountLessThan")
    func voteCountLessThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.voteCountLessThan
                == "vote_count.lte"
        )
    }

    @Test("includeVideo")
    func includeVideoQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.includeVideo == "include_video"
        )
    }

    @Test("primaryReleaseDateGreaterThan")
    func primaryReleaseDateGreaterThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.primaryReleaseDateGreaterThan
                == "primary_release_date.gte"
        )
    }

    @Test("primaryReleaseDateLessThan")
    func primaryReleaseDateLessThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.primaryReleaseDateLessThan
                == "primary_release_date.lte"
        )
    }

    @Test("firstAirDateGreaterThan")
    func firstAirDateGreaterThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.firstAirDateGreaterThan
                == "first_air_date.gte"
        )
    }

    @Test("firstAirDateLessThan")
    func firstAirDateLessThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.firstAirDateLessThan
                == "first_air_date.lte"
        )
    }

    @Test("airDateGreaterThan")
    func airDateGreaterThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.airDateGreaterThan == "air_date.gte"
        )
    }

    @Test("airDateLessThan")
    func airDateLessThanQueryItemName() {
        #expect(
            APIRequestQueryItem.Name.airDateLessThan == "air_date.lte"
        )
    }

    @Test("apiKey")
    func apiKeyQueryItemName() {
        #expect(APIRequestQueryItem.Name.apiKey == "api_key")
    }

}
