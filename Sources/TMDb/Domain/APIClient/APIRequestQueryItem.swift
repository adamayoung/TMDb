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
    static let mediaID = APIRequestQueryItem.Name("media_id")
    static let mediaType = APIRequestQueryItem.Name("media_type")

    static let withPeople = APIRequestQueryItem.Name("with_people")
    static let withOriginalLanguage = APIRequestQueryItem.Name("with_original_language")
    static let withGenres = APIRequestQueryItem.Name("with_genres")
    static let withoutGenres = APIRequestQueryItem.Name("without_genres")
    static let withCompanies = APIRequestQueryItem.Name("with_companies")
    static let withKeywords = APIRequestQueryItem.Name("with_keywords")
    static let withoutKeywords = APIRequestQueryItem.Name("without_keywords")
    static let withNetworks = APIRequestQueryItem.Name("with_networks")
    static let withWatchProviders = APIRequestQueryItem.Name("with_watch_providers")
    static let withoutWatchProviders = APIRequestQueryItem.Name("without_watch_providers")
    static let withRuntimeGreaterThan = APIRequestQueryItem.Name("with_runtime.gte")
    static let withRuntimeLessThan = APIRequestQueryItem.Name("with_runtime.lte")
    static let voteAverageGreaterThan = APIRequestQueryItem.Name("vote_average.gte")
    static let voteAverageLessThan = APIRequestQueryItem.Name("vote_average.lte")
    static let voteCountGreaterThan = APIRequestQueryItem.Name("vote_count.gte")
    static let voteCountLessThan = APIRequestQueryItem.Name("vote_count.lte")
    static let includeVideo = APIRequestQueryItem.Name("include_video")
    static let primaryReleaseDateGreaterThan = APIRequestQueryItem.Name("primary_release_date.gte")
    static let primaryReleaseDateLessThan = APIRequestQueryItem.Name("primary_release_date.lte")
    static let releaseDateGreaterThan = APIRequestQueryItem.Name("release_date.gte")
    static let releaseDateLessThan = APIRequestQueryItem.Name("release_date.lte")
    static let firstAirDateGreaterThan = APIRequestQueryItem.Name("first_air_date.gte")
    static let firstAirDateLessThan = APIRequestQueryItem.Name("first_air_date.lte")
    static let includeNullFirstAirDates =
        APIRequestQueryItem.Name("include_null_first_air_dates")
    static let airDateGreaterThan = APIRequestQueryItem.Name("air_date.gte")
    static let airDateLessThan = APIRequestQueryItem.Name("air_date.lte")

    static let certification = APIRequestQueryItem.Name("certification")
    static let certificationMin = APIRequestQueryItem.Name("certification.gte")
    static let certificationMax = APIRequestQueryItem.Name("certification.lte")
    static let certificationCountry = APIRequestQueryItem.Name("certification_country")
    static let withReleaseType = APIRequestQueryItem.Name("with_release_type")
    static let withCast = APIRequestQueryItem.Name("with_cast")
    static let withCrew = APIRequestQueryItem.Name("with_crew")
    static let withOriginCountry = APIRequestQueryItem.Name("with_origin_country")
    static let withoutCompanies = APIRequestQueryItem.Name("without_companies")
    static let withWatchMonetizationTypes = APIRequestQueryItem.Name("with_watch_monetization_types")
    static let withStatus = APIRequestQueryItem.Name("with_status")
    static let withType = APIRequestQueryItem.Name("with_type")
    static let screenedTheatrically = APIRequestQueryItem.Name("screened_theatrically")

    static let apiKey = APIRequestQueryItem.Name("api_key")
    static let externalSource = APIRequestQueryItem.Name("external_source")
    static let timezone = APIRequestQueryItem.Name("timezone")
    static let country = APIRequestQueryItem.Name("country")
    /// No shared `startDate`/`endDate` here, deliberately. `Value` is
    /// `CustomStringConvertible`, so `self[ifPresent: .startDate] = someDate`
    /// compiles and stringifies via `Date.description` — sending
    /// "2024-01-01 00:00:00 +0000" and bypassing the GMT pin that
    /// `DateFormatter.theMovieDatabase` carries. That is the bug #426 removed
    /// from the two movie changes requests. Each `*ChangesRequest` declares its
    /// own name and formats through the formatter; keep it that way.
    static let appendToResponse = APIRequestQueryItem.Name("append_to_response")

}

extension APIRequestQueryItems {

    /// Sets the query item for `key` to `newValue`, treating `nil` as a no-op.
    ///
    /// Unlike the raw `Dictionary` subscript — where assigning `nil` removes the key —
    /// assigning `nil` here leaves the collection unchanged. This lets an optional value
    /// be applied in a single line without an `if let` guard, and without an incoming
    /// `nil` clearing a value that was set earlier.
    subscript(ifPresent key: Key) -> Value? {
        get { self[key] }
        set {
            guard let newValue else {
                return
            }
            self[key] = newValue
        }
    }

    static func idsQueryItemValue(for ids: [Int]) -> String {
        ids.map(\.description).joined(separator: ",")
    }

}
