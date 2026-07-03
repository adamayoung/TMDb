//
//  TVSeasonDetailsResponse.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A TV season details response with optional appended data.
///
/// Use with
/// ``TVSeasonService/details(forSeason:inTVSeries:appending:language:)``
/// to fetch TV season details and related data in a single
/// request.
///
public struct TVSeasonDetailsResponse: Equatable, Hashable,
Sendable {

    ///
    /// The TV season details.
    ///
    public let season: TVSeason

    ///
    /// Cast and crew credits.
    ///
    public let credits: ShowCredits?

    ///
    /// Aggregate credits.
    ///
    public let aggregateCredits: TVSeasonAggregateCredits?

    ///
    /// Image collection.
    ///
    public let images: ImageCollection?

    ///
    /// Video collection.
    ///
    public let videos: VideoCollection?

    ///
    /// Translations.
    ///
    public let translations: [Translation<TVSeasonTranslationData>]?

    ///
    /// Watch providers by country code.
    ///
    public let watchProviders: [String: ShowWatchProvider]?

    ///
    /// External IDs and links.
    ///
    public let externalIDs: TVSeasonExternalLinksCollection?

    ///
    /// Creates a TV season details response.
    ///
    /// - Parameters:
    ///   - season: The TV season details.
    ///   - credits: Cast and crew credits.
    ///   - aggregateCredits: Aggregate credits.
    ///   - images: Image collection.
    ///   - videos: Video collection.
    ///   - translations: Translations.
    ///   - watchProviders: Watch providers by country code.
    ///   - externalIDs: External IDs and links.
    ///
    public init(
        season: TVSeason,
        credits: ShowCredits? = nil,
        aggregateCredits: TVSeasonAggregateCredits? = nil,
        images: ImageCollection? = nil,
        videos: VideoCollection? = nil,
        translations: [Translation<TVSeasonTranslationData>]? = nil,
        watchProviders: [String: ShowWatchProvider]? = nil,
        externalIDs: TVSeasonExternalLinksCollection? = nil
    ) {
        self.season = season
        self.credits = credits
        self.aggregateCredits = aggregateCredits
        self.images = images
        self.videos = videos
        self.translations = translations
        self.watchProviders = watchProviders
        self.externalIDs = externalIDs
    }

}

extension TVSeasonDetailsResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case credits
        case aggregateCredits
        case images
        case videos
        case translations
        case watchProviders = "watch/providers"
        case externalIDs = "externalIds"
    }

    public init(from decoder: Decoder) throws {
        self.season = try TVSeason(from: decoder)
        let id = season.id

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.credits = try container
            .decodeCastAndCrewIfPresent(CastMember.self, CrewMember.self, forKey: .credits)
            .map { ShowCredits(id: id, cast: $0.cast, crew: $0.crew) }

        self.aggregateCredits = try container
            .decodeCastAndCrewIfPresent(
                AggregateCastMember.self, AggregateCrewMember.self, forKey: .aggregateCredits
            )
            .map { TVSeasonAggregateCredits(id: id, cast: $0.cast, crew: $0.crew) }

        self.images = try ImageCollection(from: container, forKey: .images, id: id)

        self.videos = try container
            .decodeNestedArrayIfPresent(VideoMetadata.self, forKey: .videos, nestedKey: "results")
            .map { VideoCollection(id: id, results: $0) }

        self.translations = try container.decodeNestedIfPresent(
            [Translation<TVSeasonTranslationData>].self,
            forKey: .translations,
            nestedKey: "translations"
        )

        self.watchProviders = try container.decodeNestedIfPresent(
            [String: ShowWatchProvider].self,
            forKey: .watchProviders,
            nestedKey: "results"
        )

        self.externalIDs = try SocialLinkIDs(from: container, forKey: .externalIDs)
            .map { TVSeasonExternalLinksCollection(id: id, wikiData: WikiDataLink(wikiDataID: $0.wikiDataID)) }
    }

}
