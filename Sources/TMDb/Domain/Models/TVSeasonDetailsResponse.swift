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

    private enum CreditsCodingKeys: String, CodingKey {
        case cast
        case crew
    }

    private enum ImagesCodingKeys: String, CodingKey {
        case posters
    }

    private enum VideosCodingKeys: String, CodingKey {
        case results
    }

    private enum TranslationsCodingKeys: String, CodingKey {
        case translations
    }

    private enum ResultsCodingKeys: String, CodingKey {
        case results
    }

    private enum ExternalIDsCodingKeys: String, CodingKey {
        case wikiDataID = "wikidataId"
    }

    // swiftlint:disable function_body_length
    public init(from decoder: Decoder) throws {
        self.season = try TVSeason(from: decoder)

        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        if container.contains(.credits) {
            let nested = try container.nestedContainer(
                keyedBy: CreditsCodingKeys.self,
                forKey: .credits
            )
            let cast = try nested.decodeIfPresent(
                [CastMember].self, forKey: .cast
            ) ?? []
            let crew = try nested.decodeIfPresent(
                [CrewMember].self, forKey: .crew
            ) ?? []
            self.credits = ShowCredits(
                id: season.id, cast: cast, crew: crew
            )
        } else {
            self.credits = nil
        }

        if container.contains(.aggregateCredits) {
            let nested = try container.nestedContainer(
                keyedBy: CreditsCodingKeys.self,
                forKey: .aggregateCredits
            )
            let cast = try nested.decodeIfPresent(
                [AggregateCastMember].self, forKey: .cast
            ) ?? []
            let crew = try nested.decodeIfPresent(
                [AggregateCrewMember].self, forKey: .crew
            ) ?? []
            self.aggregateCredits = TVSeasonAggregateCredits(
                id: season.id, cast: cast, crew: crew
            )
        } else {
            self.aggregateCredits = nil
        }

        if container.contains(.images) {
            let nested = try container.nestedContainer(
                keyedBy: ImagesCodingKeys.self,
                forKey: .images
            )
            let posters = try nested.decodeIfPresent(
                [ImageMetadata].self, forKey: .posters
            ) ?? []
            self.images = ImageCollection(
                id: season.id,
                posters: posters,
                logos: [],
                backdrops: []
            )
        } else {
            self.images = nil
        }

        if container.contains(.videos) {
            let nested = try container.nestedContainer(
                keyedBy: VideosCodingKeys.self,
                forKey: .videos
            )
            let results = try nested.decodeIfPresent(
                [VideoMetadata].self, forKey: .results
            ) ?? []
            self.videos = VideoCollection(
                id: season.id, results: results
            )
        } else {
            self.videos = nil
        }

        if container.contains(.translations) {
            let nested = try container.nestedContainer(
                keyedBy: TranslationsCodingKeys.self,
                forKey: .translations
            )
            self.translations = try nested.decodeIfPresent(
                [Translation<TVSeasonTranslationData>].self,
                forKey: .translations
            )
        } else {
            self.translations = nil
        }

        if container.contains(.watchProviders) {
            let nested = try container.nestedContainer(
                keyedBy: ResultsCodingKeys.self,
                forKey: .watchProviders
            )
            self.watchProviders = try nested.decodeIfPresent(
                [String: ShowWatchProvider].self,
                forKey: .results
            )
        } else {
            self.watchProviders = nil
        }

        if container.contains(.externalIDs) {
            let nested = try container.nestedContainer(
                keyedBy: ExternalIDsCodingKeys.self,
                forKey: .externalIDs
            )
            let wikiDataID = try nested.decodeIfPresent(
                String.self, forKey: .wikiDataID
            )
            self.externalIDs = TVSeasonExternalLinksCollection(
                id: season.id,
                wikiData: WikiDataLink(
                    wikiDataID: wikiDataID
                )
            )
        } else {
            self.externalIDs = nil
        }
    }
    // swiftlint:enable function_body_length

}
