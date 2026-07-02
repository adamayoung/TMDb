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

    public init(from decoder: Decoder) throws {
        self.episode = try TVEpisode(from: decoder)
        let id = episode.id

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.credits = try container
            .decodeCastAndCrewIfPresent(CastMember.self, CrewMember.self, forKey: .credits)
            .map { ShowCredits(id: id, cast: $0.cast, crew: $0.crew) }

        self.images = try container
            .decodeNestedArrayIfPresent(ImageMetadata.self, forKey: .images, nestedKey: "stills")
            .map { TVEpisodeImageCollection(id: id, stills: $0) }

        self.videos = try container
            .decodeNestedArrayIfPresent(VideoMetadata.self, forKey: .videos, nestedKey: "results")
            .map { VideoCollection(id: id, results: $0) }

        self.translations = try container.decodeNestedIfPresent(
            [Translation<TVEpisodeTranslationData>].self,
            forKey: .translations,
            nestedKey: "translations"
        )

        self.externalIDs = try SocialLinkIDs(from: container, forKey: .externalIDs)
            .map {
                TVEpisodeExternalLinksCollection(
                    id: id,
                    imdb: IMDbLink(imdbTitleID: $0.imdbID),
                    wikiData: WikiDataLink(wikiDataID: $0.wikiDataID)
                )
            }
    }

}
