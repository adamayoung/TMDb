//
//  TVEpisodeDetailsResponse.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A TV episode details response with optional appended data.
///
/// Use with
/// ``TVEpisodeService/details(forEpisode:inSeason:inTVSeries:appending:language:)``
/// to fetch TV episode details and related data in a single
/// request.
///
public struct TVEpisodeDetailsResponse: Equatable, Hashable,
Sendable {

    ///
    /// The TV episode details.
    ///
    public let episode: TVEpisode

    ///
    /// Cast and crew credits.
    ///
    public let credits: ShowCredits?

    ///
    /// Image collection.
    ///
    public let images: TVEpisodeImageCollection?

    ///
    /// Video collection.
    ///
    public let videos: VideoCollection?

    ///
    /// Translations.
    ///
    public let translations: [Translation<TVEpisodeTranslationData>]?

    ///
    /// External IDs and links.
    ///
    public let externalIDs: TVEpisodeExternalLinksCollection?

    ///
    /// Creates a TV episode details response.
    ///
    /// - Parameters:
    ///   - episode: The TV episode details.
    ///   - credits: Cast and crew credits.
    ///   - images: Image collection.
    ///   - videos: Video collection.
    ///   - translations: Translations.
    ///   - externalIDs: External IDs and links.
    ///
    public init(
        episode: TVEpisode,
        credits: ShowCredits? = nil,
        images: TVEpisodeImageCollection? = nil,
        videos: VideoCollection? = nil,
        translations: [Translation<TVEpisodeTranslationData>]? = nil,
        externalIDs: TVEpisodeExternalLinksCollection? = nil
    ) {
        self.episode = episode
        self.credits = credits
        self.images = images
        self.videos = videos
        self.translations = translations
        self.externalIDs = externalIDs
    }

}

extension TVEpisodeDetailsResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case credits
        case images
        case videos
        case translations
        case externalIDs = "externalIds"
    }

    private enum CreditsCodingKeys: String, CodingKey {
        case cast
        case crew
    }

    private enum StillsCodingKeys: String, CodingKey {
        case stills
    }

    private enum VideosCodingKeys: String, CodingKey {
        case results
    }

    private enum TranslationsCodingKeys: String, CodingKey {
        case translations
    }

    private enum ExternalIDsCodingKeys: String, CodingKey {
        case imdbID = "imdbId"
        case wikiDataID = "wikidataId"
    }

    // swiftlint:disable function_body_length
    public init(from decoder: Decoder) throws {
        self.episode = try TVEpisode(from: decoder)

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
                id: episode.id, cast: cast, crew: crew
            )
        } else {
            self.credits = nil
        }

        if container.contains(.images) {
            let nested = try container.nestedContainer(
                keyedBy: StillsCodingKeys.self,
                forKey: .images
            )
            let stills = try nested.decodeIfPresent(
                [ImageMetadata].self, forKey: .stills
            ) ?? []
            self.images = TVEpisodeImageCollection(
                id: episode.id, stills: stills
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
                id: episode.id, results: results
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
                [Translation<TVEpisodeTranslationData>].self,
                forKey: .translations
            )
        } else {
            self.translations = nil
        }

        if container.contains(.externalIDs) {
            let nested = try container.nestedContainer(
                keyedBy: ExternalIDsCodingKeys.self,
                forKey: .externalIDs
            )
            let imdbID = try nested.decodeIfPresent(
                String.self, forKey: .imdbID
            )
            let wikiDataID = try nested.decodeIfPresent(
                String.self, forKey: .wikiDataID
            )
            self.externalIDs = TVEpisodeExternalLinksCollection(
                id: episode.id,
                imdb: IMDbLink(imdbTitleID: imdbID),
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
