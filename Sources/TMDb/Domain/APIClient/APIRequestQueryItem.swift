//
//  APIRequestQueryItem.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

typealias APIRequestQueryItems = [APIRequestQueryItem.Name: CustomStringConvertible]

enum APIRequestQueryItem {

    struct Name: ExpressibleByStringLiteral, CustomStringConvertible, Equatable, Hashable {

        private let name: String

        init(_ name: String) {
            self.name = name
        }

        init(stringLiteral: String) {
            self.init(stringLiteral)
        }

        var description: String {
            name
        }

    }

}

extension APIRequestQueryItem.Name {

    static let page = APIRequestQueryItem.Name("page")
    static let sortBy = APIRequestQueryItem.Name("sort_by")
    static let watchRegion = APIRequestQueryItem.Name("watch_region")
    static let includeImageLanguage = APIRequestQueryItem.Name("include_image_language")
    static let includeVideoLanguage = APIRequestQueryItem.Name("include_video_language")
    static let includeAdult = APIRequestQueryItem.Name("include_adult")
    static let query = APIRequestQueryItem.Name("query")
    static let year = APIRequestQueryItem.Name("year")
    static let primaryReleaseYear = APIRequestQueryItem.Name("primary_release_year")
    static let firstAirDateYear = APIRequestQueryItem.Name("first_air_date_year")
    static let sessionID = APIRequestQueryItem.Name("session_id")
    static let language = APIRequestQueryItem.Name("language")
    static let region = APIRequestQueryItem.Name("region")

    static let withPeople = APIRequestQueryItem.Name("with_people")
    static let withOriginalLanguage = APIRequestQueryItem.Name("with_original_language")
    static let withGenres = APIRequestQueryItem.Name("with_genres")
    static let withoutGenres = APIRequestQueryItem.Name("without_genres")
    static let withCompanies = APIRequestQueryItem.Name("with_companies")
    static let withKeywords = APIRequestQueryItem.Name("with_keywords")
    static let withoutKeywords = APIRequestQueryItem.Name("without_keywords")
    static let withNetworks = APIRequestQueryItem.Name("with_networks")
    static let withWatchProviders = APIRequestQueryItem.Name("with_watch_providers")
    static let withRuntimeGreaterThan = APIRequestQueryItem.Name("with_runtime.gte")
    static let withRuntimeLessThan = APIRequestQueryItem.Name("with_runtime.lte")
    static let voteAverageGreaterThan = APIRequestQueryItem.Name("vote_average.gte")
    static let voteAverageLessThan = APIRequestQueryItem.Name("vote_average.lte")
    static let voteCountGreaterThan = APIRequestQueryItem.Name("vote_count.gte")
    static let voteCountLessThan = APIRequestQueryItem.Name("vote_count.lte")
    static let includeVideo = APIRequestQueryItem.Name("include_video")
    static let primaryReleaseDateGreaterThan = APIRequestQueryItem.Name("primary_release_date.gte")
    static let primaryReleaseDateLessThan = APIRequestQueryItem.Name("primary_release_date.lte")
    static let firstAirDateGreaterThan = APIRequestQueryItem.Name("first_air_date.gte")
    static let firstAirDateLessThan = APIRequestQueryItem.Name("first_air_date.lte")
    static let airDateGreaterThan = APIRequestQueryItem.Name("air_date.gte")
    static let airDateLessThan = APIRequestQueryItem.Name("air_date.lte")

    static let apiKey = APIRequestQueryItem.Name("api_key")
    static let externalSource = APIRequestQueryItem.Name("external_source")
    static let timezone = APIRequestQueryItem.Name("timezone")
    static let country = APIRequestQueryItem.Name("country")
    static let startDate = APIRequestQueryItem.Name("start_date")
    static let endDate = APIRequestQueryItem.Name("end_date")
    static let appendToResponse = APIRequestQueryItem.Name("append_to_response")

}
