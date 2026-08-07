//
//  V4ListSummary.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a v4 list without its items, as returned when listing
/// an account's lists.
///
/// - Note: This is a separate model from ``V4List`` rather than a subset of it,
///   because the two endpoints disagree on the *types* of the fields they
///   share: `public` is a boolean on the list-details endpoint but `0`/`1`
///   here, `sort_by` is a string there but an integer here, and `runtime` is a
///   number there but a string here. Each raw value is stored as the wire sends
///   it and exposed through a computed property, so `Codable` stays synthesized
///   and correct in both directions.
///
public struct V4ListSummary: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// List identifier.
    ///
    public let id: Int

    ///
    /// List name.
    ///
    public let name: String

    ///
    /// List description.
    ///
    public let description: String?

    ///
    /// The account object identifier of the list's owner.
    ///
    public let accountObjectID: String

    ///
    /// Number of items in the list.
    ///
    public let numberOfItems: Int

    ///
    /// Average rating of the list's items.
    ///
    public let averageRating: Double

    ///
    /// Combined revenue of the list's items.
    ///
    public let revenue: Int

    ///
    /// ISO 639-1 language code.
    ///
    public let languageCode: String

    ///
    /// ISO 3166-1 country code.
    ///
    public let countryCode: String

    ///
    /// Path to the list's backdrop image.
    ///
    public let backdropPath: URL?

    ///
    /// Path to the list's poster image.
    ///
    public let posterPath: URL?

    ///
    /// When the list was created.
    ///
    public let createdAt: Date

    ///
    /// When the list was last updated.
    ///
    public let updatedAt: Date

    ///
    /// The order the list is sorted in, as TMDb's numeric identifier.
    ///
    /// - Note: This endpoint reports the sort order as an integer, while
    ///   ``V4List/sortBy`` reports it as a string. TMDb publishes no mapping
    ///   between the two, so both are exposed exactly as sent rather than
    ///   decoded into a shared type.
    ///
    public let sortBy: Int

    // The wire sends these as `0`/`1` and as a string; stored raw so `Codable`,
    // `Equatable` and `Hashable` all stay synthesized at wire granularity.
    private let publicValue: Int
    private let adultValue: Int
    private let featuredValue: Int
    private let runtimeValue: String

    ///
    /// Whether the list is visible to everyone.
    ///
    public var isPublic: Bool {
        publicValue != 0
    }

    ///
    /// Whether the list is flagged as adult.
    ///
    public var isAdult: Bool {
        adultValue != 0
    }

    ///
    /// Whether the list is featured by TMDb.
    ///
    public var isFeatured: Bool {
        featuredValue != 0
    }

    ///
    /// Combined runtime of the list's items, in minutes.
    ///
    /// Returns `0` when TMDb sends a value that is not a number.
    ///
    public var runtime: Int {
        Int(runtimeValue) ?? 0
    }

    ///
    /// Creates a v4 list summary object.
    ///
    /// - Parameters:
    ///    - id: List identifier.
    ///    - name: List name.
    ///    - description: List description.
    ///    - accountObjectID: The account object identifier of the list's owner.
    ///    - numberOfItems: Number of items in the list.
    ///    - isPublic: Whether the list is visible to everyone.
    ///    - isAdult: Whether the list is flagged as adult.
    ///    - isFeatured: Whether the list is featured by TMDb.
    ///    - runtime: Combined runtime of the list's items, in minutes.
    ///    - averageRating: Average rating of the list's items.
    ///    - revenue: Combined revenue of the list's items.
    ///    - sortBy: The order the list is sorted in, as TMDb's numeric identifier.
    ///    - languageCode: ISO 639-1 language code.
    ///    - countryCode: ISO 3166-1 country code.
    ///    - backdropPath: Path to the list's backdrop image.
    ///    - posterPath: Path to the list's poster image.
    ///    - createdAt: When the list was created.
    ///    - updatedAt: When the list was last updated.
    ///
    public init(
        id: Int,
        name: String,
        description: String? = nil,
        accountObjectID: String,
        numberOfItems: Int,
        isPublic: Bool,
        isAdult: Bool = false,
        isFeatured: Bool = false,
        runtime: Int = 0,
        averageRating: Double = 0,
        revenue: Int = 0,
        sortBy: Int = 1,
        languageCode: String,
        countryCode: String,
        backdropPath: URL? = nil,
        posterPath: URL? = nil,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.accountObjectID = accountObjectID
        self.numberOfItems = numberOfItems
        self.publicValue = isPublic ? 1 : 0
        self.adultValue = isAdult ? 1 : 0
        self.featuredValue = isFeatured ? 1 : 0
        self.runtimeValue = String(runtime)
        self.averageRating = averageRating
        self.revenue = revenue
        self.sortBy = sortBy
        self.languageCode = languageCode
        self.countryCode = countryCode
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

}

extension V4ListSummary {

    /// With `.convertFromSnakeCase` the decoder hands over the camelCased form,
    /// so these raw values must be spelled that way — `iso6391`, not `iso_639_1`.
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case accountObjectID = "accountObjectId"
        case numberOfItems
        case averageRating
        case revenue
        case sortBy
        case languageCode = "iso6391"
        case countryCode = "iso31661"
        case backdropPath
        case posterPath
        case createdAt
        case updatedAt
        case publicValue = "public"
        case adultValue = "adult"
        case featuredValue = "featured"
        case runtimeValue = "runtime"
    }

}
