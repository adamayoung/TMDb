//
//  V4List.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a v4 list — a user-created list that can hold both
/// movies and TV series.
///
public struct V4List: Identifiable, Codable, Equatable, Hashable, Sendable {

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
    /// Whether the list is visible to everyone.
    ///
    public let isPublic: Bool

    ///
    /// The user who created the list.
    ///
    public let createdBy: V4ListCreator

    ///
    /// The items on this page of the list.
    ///
    /// Named for symmetry with `MediaList.items`; TMDb sends it as `results`.
    ///
    public let items: [V4ListItem]

    ///
    /// Number of items in the whole list, across every page.
    ///
    public let itemCount: Int

    ///
    /// Average rating of the list's items.
    ///
    public let averageRating: Double

    ///
    /// Combined runtime of the list's items, in minutes.
    ///
    public let runtime: Int

    ///
    /// Combined revenue of the list's items.
    ///
    public let revenue: Int

    ///
    /// The order the list is sorted in, as TMDb reports it, e.g.
    /// `original_order.asc`.
    ///
    /// - Note: This is the raw value rather than a ``V4ListSortBy``. The v4 API
    ///   reports the sort order as a *string* here but as an *integer* on
    ///   ``V4ListSummary``, and publishes no mapping between the two — so
    ///   decoding either into a shared type would be inventing a contract.
    ///
    public let sortBy: String

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
    /// Page number.
    ///
    public let page: Int

    ///
    /// Total number of pages.
    ///
    public let totalPages: Int

    ///
    /// Total number of results.
    ///
    public let totalResults: Int

    ///
    /// How many items were skipped while decoding this page because their media
    /// type is one this library does not model.
    ///
    /// Decode telemetry, not data: it exists so tests can assert that a page is
    /// short for a known reason rather than a regression. It is zero for a list
    /// built in code.
    ///
    private let droppedItems: DroppedItemCount

    ///
    /// How many items were skipped while decoding this page.
    ///
    package var droppedItemCount: Int {
        droppedItems.value
    }

    ///
    /// Creates a v4 list object.
    ///
    /// - Parameters:
    ///    - id: List identifier.
    ///    - name: List name.
    ///    - description: List description.
    ///    - isPublic: Whether the list is visible to everyone.
    ///    - createdBy: The user who created the list.
    ///    - items: The items on this page of the list.
    ///    - itemCount: Number of items in the whole list.
    ///    - averageRating: Average rating of the list's items.
    ///    - runtime: Combined runtime of the list's items, in minutes.
    ///    - revenue: Combined revenue of the list's items.
    ///    - sortBy: The order the list is sorted in, as TMDb reports it.
    ///    - languageCode: ISO 639-1 language code.
    ///    - countryCode: ISO 3166-1 country code.
    ///    - backdropPath: Path to the list's backdrop image.
    ///    - posterPath: Path to the list's poster image.
    ///    - page: Page number.
    ///    - totalPages: Total number of pages.
    ///    - totalResults: Total number of results.
    ///
    public init(
        id: Int,
        name: String,
        description: String? = nil,
        isPublic: Bool,
        createdBy: V4ListCreator,
        items: [V4ListItem] = [],
        itemCount: Int,
        averageRating: Double = 0,
        runtime: Int = 0,
        revenue: Int = 0,
        sortBy: String,
        languageCode: String,
        countryCode: String,
        backdropPath: URL? = nil,
        posterPath: URL? = nil,
        page: Int = 1,
        totalPages: Int = 1,
        totalResults: Int = 0
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.isPublic = isPublic
        self.createdBy = createdBy
        self.items = items
        self.itemCount = itemCount
        self.averageRating = averageRating
        self.runtime = runtime
        self.revenue = revenue
        self.sortBy = sortBy
        self.languageCode = languageCode
        self.countryCode = countryCode
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.droppedItems = .none
    }

}

extension V4List {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case isPublic = "public"
        case createdBy
        case items = "results"
        case itemCount
        case averageRating
        case runtime
        case revenue
        case sortBy
        case languageCode = "iso6391"
        case countryCode = "iso31661"
        case backdropPath
        case posterPath
        case page
        case totalPages
        case totalResults
        case comments
    }

    ///
    /// Creates a v4 list by decoding from the given decoder.
    ///
    /// Item comments are **not** sent alongside the items. TMDb sends a
    /// separate top-level `comments` dictionary keyed by `"<media_type>:<id>"`
    /// — for example `"movie:550"` or `"tv:1399"` — with nullable values, so
    /// each comment is matched back onto its item here.
    ///
    /// An item whose media type this library does not model is skipped rather
    /// than failing the whole page. Every other decode failure throws.
    ///
    /// - Important: A skipped item is **not detectable from outside the
    ///   package** — the count is recorded internally for tests, not exposed to
    ///   callers. ``itemCount`` is no substitute: it is the size of the whole
    ///   list across every page, not of ``items``, so the two differ
    ///   legitimately whenever the list is longer than a page. They are only
    ///   comparable for a single-page list.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if reading from the decoder fails, or if the data is
    ///   corrupted or otherwise invalid.
    ///
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        // Absent visibility defaults to *private*: for a privacy flag the safe
        // failure direction is the restrictive one.
        self.isPublic = try container.decodeIfPresent(Bool.self, forKey: .isPublic) ?? false
        self.createdBy = try container.decode(V4ListCreator.self, forKey: .createdBy)
        self.itemCount = try container.decodeIfPresent(Int.self, forKey: .itemCount) ?? 0
        self.averageRating = try container.decodeIfPresent(Double.self, forKey: .averageRating) ?? 0
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime) ?? 0
        self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue) ?? 0
        self.sortBy = try container.decodeIfPresent(String.self, forKey: .sortBy)
            ?? V4ListSortBy.originalOrder().description
        self.languageCode = try container.decodeIfPresent(String.self, forKey: .languageCode) ?? ""
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode) ?? ""
        self.backdropPath = try container.decodeIfPresent(URL.self, forKey: .backdropPath)
        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? 1
        self.totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? 1
        self.totalResults = try container.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0

        let decodedItems = try container.decodeSkippingUnknownMediaTypes(
            Show.self,
            forKey: .items
        )
        let media = decodedItems.elements
        self.droppedItems = DroppedItemCount(decodedItems.dropped)
        let comments = try container.decodeIfPresent(
            [String: String?].self,
            forKey: .comments
        ) ?? [:]

        self.items = media.map { show in
            V4ListItem(media: show, comment: comments[Self.commentKey(for: show)] ?? nil)
        }
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// Item comments are written back into the top-level `comments` dictionary,
    /// in the `"<media_type>:<id>"` shape TMDb sends, so a decode/encode round
    /// trip preserves them.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - Throws: An error if any values are invalid for the given encoder's
    ///   format.
    ///
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(isPublic, forKey: .isPublic)
        try container.encode(createdBy, forKey: .createdBy)
        // Encode the items, not their media: `V4ListItem` adds the `media_type`
        // discriminator that `Show` does not write, and without it the items
        // cannot be decoded back.
        try container.encode(items, forKey: .items)
        try container.encode(itemCount, forKey: .itemCount)
        try container.encode(averageRating, forKey: .averageRating)
        try container.encode(runtime, forKey: .runtime)
        try container.encode(revenue, forKey: .revenue)
        try container.encode(sortBy, forKey: .sortBy)
        try container.encode(languageCode, forKey: .languageCode)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(backdropPath, forKey: .backdropPath)
        try container.encodeIfPresent(posterPath, forKey: .posterPath)
        try container.encode(page, forKey: .page)
        try container.encode(totalPages, forKey: .totalPages)
        try container.encode(totalResults, forKey: .totalResults)

        let comments = items.reduce(into: [String: String?]()) { result, item in
            guard let comment = item.comment else {
                return
            }
            result[Self.commentKey(for: item.media)] = comment
        }
        if !comments.isEmpty {
            try container.encode(comments, forKey: .comments)
        }
    }

    private static func commentKey(for show: Show) -> String {
        let mediaType = switch show {
        case .movie: ShowType.movie
        case .tvSeries: ShowType.tvSeries
        }

        return "\(mediaType.rawValue):\(show.id)"
    }

}
