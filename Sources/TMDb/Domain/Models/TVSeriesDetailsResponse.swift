//
//  TVSeriesDetailsResponse.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A TV series details response with optional appended data.
///
/// Use with
/// ``TVSeriesService/details(forTVSeries:appending:language:)``
/// to fetch TV series details and related data in a single
/// request.
///
public struct TVSeriesDetailsResponse: Equatable, Hashable,
Sendable {

    ///
    /// The TV series details.
    ///
    public let tvSeries: TVSeries

    ///
    /// Cast and crew credits.
    ///
    public let credits: ShowCredits?

    ///
    /// Aggregate credits.
    ///
    public let aggregateCredits: TVSeriesAggregateCredits?

    ///
    /// Image collection.
    ///
    public let images: ImageCollection?

    ///
    /// Video collection.
    ///
    public let videos: VideoCollection?

    ///
    /// User reviews.
    ///
    public let reviews: ReviewPageableList?

    ///
    /// Recommended TV series.
    ///
    public let recommendations: TVSeriesPageableList?

    ///
    /// Similar TV series.
    ///
    public let similar: TVSeriesPageableList?

    ///
    /// Content ratings by country.
    ///
    public let contentRatings: [ContentRating]?

    ///
    /// Alternative titles.
    ///
    public let alternativeTitles: [AlternativeTitle]?

    ///
    /// Translations.
    ///
    public let translations: [Translation<TVSeriesTranslationData>]?

    ///
    /// Keywords.
    ///
    public let keywords: [Keyword]?

    ///
    /// Watch providers by country code.
    ///
    public let watchProviders: [String: ShowWatchProvider]?

    ///
    /// External IDs and links.
    ///
    public let externalIDs: TVSeriesExternalLinksCollection?

    ///
    /// Episodes screened theatrically.
    ///
    public let screenedTheatrically: [ScreenedTheatricallyResult]?

    ///
    /// Episode groups.
    ///
    public let episodeGroups: [TVEpisodeGroup]?

    ///
    /// Lists containing this TV series.
    ///
    public let lists: MediaPageableList?

    ///
    /// Change history.
    ///
    public let changes: ChangeCollection?

    ///
    /// Creates a TV series details response.
    ///
    /// - Parameters:
    ///   - tvSeries: The TV series details.
    ///   - credits: Cast and crew credits.
    ///   - aggregateCredits: Aggregate credits.
    ///   - images: Image collection.
    ///   - videos: Video collection.
    ///   - reviews: User reviews.
    ///   - recommendations: Recommended TV series.
    ///   - similar: Similar TV series.
    ///   - contentRatings: Content ratings by country.
    ///   - alternativeTitles: Alternative titles.
    ///   - translations: Translations.
    ///   - keywords: Keywords.
    ///   - watchProviders: Watch providers by country code.
    ///   - externalIDs: External IDs and links.
    ///   - screenedTheatrically: Screened theatrically.
    ///   - episodeGroups: Episode groups.
    ///   - lists: Lists containing this TV series.
    ///   - changes: Change history.
    ///
    public init(
        tvSeries: TVSeries,
        credits: ShowCredits? = nil,
        aggregateCredits: TVSeriesAggregateCredits? = nil,
        images: ImageCollection? = nil,
        videos: VideoCollection? = nil,
        reviews: ReviewPageableList? = nil,
        recommendations: TVSeriesPageableList? = nil,
        similar: TVSeriesPageableList? = nil,
        contentRatings: [ContentRating]? = nil,
        alternativeTitles: [AlternativeTitle]? = nil,
        translations: [Translation<TVSeriesTranslationData>]? = nil,
        keywords: [Keyword]? = nil,
        watchProviders: [String: ShowWatchProvider]? = nil,
        externalIDs: TVSeriesExternalLinksCollection? = nil,
        screenedTheatrically: [ScreenedTheatricallyResult]? = nil,
        episodeGroups: [TVEpisodeGroup]? = nil,
        lists: MediaPageableList? = nil,
        changes: ChangeCollection? = nil
    ) {
        self.tvSeries = tvSeries
        self.credits = credits
        self.aggregateCredits = aggregateCredits
        self.images = images
        self.videos = videos
        self.reviews = reviews
        self.recommendations = recommendations
        self.similar = similar
        self.contentRatings = contentRatings
        self.alternativeTitles = alternativeTitles
        self.translations = translations
        self.keywords = keywords
        self.watchProviders = watchProviders
        self.externalIDs = externalIDs
        self.screenedTheatrically = screenedTheatrically
        self.episodeGroups = episodeGroups
        self.lists = lists
        self.changes = changes
    }

}

extension TVSeriesDetailsResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case credits
        case aggregateCredits
        case images
        case videos
        case reviews
        case recommendations
        case similar
        case contentRatings
        case alternativeTitles
        case translations
        case keywords
        case watchProviders = "watch/providers"
        case externalIDs = "externalIds"
        case screenedTheatrically
        case episodeGroups
        case lists
        case changes
    }

    // swiftlint:disable:next function_body_length
    public init(from decoder: Decoder) throws {
        self.tvSeries = try TVSeries(from: decoder)
        let id = tvSeries.id

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.credits = try container
            .decodeCastAndCrewIfPresent(CastMember.self, CrewMember.self, forKey: .credits)
            .map { ShowCredits(id: id, cast: $0.cast, crew: $0.crew) }

        self.aggregateCredits = try container
            .decodeCastAndCrewIfPresent(
                AggregateCastMember.self, AggregateCrewMember.self, forKey: .aggregateCredits
            )
            .map { TVSeriesAggregateCredits(id: id, cast: $0.cast, crew: $0.crew) }

        self.images = try container.decodeImageCollectionIfPresent(forKey: .images, id: id)

        self.videos = try container
            .decodeNestedArrayIfPresent(VideoMetadata.self, forKey: .videos, nestedKey: "results")
            .map { VideoCollection(id: id, results: $0) }

        self.reviews = try container.decodeIfPresent(
            ReviewPageableList.self, forKey: .reviews
        )
        self.recommendations = try container.decodeIfPresent(
            TVSeriesPageableList.self, forKey: .recommendations
        )
        self.similar = try container.decodeIfPresent(
            TVSeriesPageableList.self, forKey: .similar
        )
        self.lists = try container.decodeIfPresent(
            MediaPageableList.self, forKey: .lists
        )
        self.changes = try container.decodeIfPresent(
            ChangeCollection.self, forKey: .changes
        )

        self.contentRatings = try container.decodeNestedIfPresent(
            [ContentRating].self, forKey: .contentRatings, nestedKey: "results"
        )
        self.alternativeTitles = try container.decodeNestedIfPresent(
            [AlternativeTitle].self, forKey: .alternativeTitles, nestedKey: "results"
        )
        self.translations = try container.decodeNestedIfPresent(
            [Translation<TVSeriesTranslationData>].self, forKey: .translations, nestedKey: "translations"
        )
        self.keywords = try container.decodeNestedIfPresent(
            [Keyword].self, forKey: .keywords, nestedKey: "results"
        )
        self.watchProviders = try container.decodeNestedIfPresent(
            [String: ShowWatchProvider].self, forKey: .watchProviders, nestedKey: "results"
        )
        self.screenedTheatrically = try container.decodeNestedIfPresent(
            [ScreenedTheatricallyResult].self, forKey: .screenedTheatrically, nestedKey: "results"
        )
        self.episodeGroups = try container.decodeNestedIfPresent(
            [TVEpisodeGroup].self, forKey: .episodeGroups, nestedKey: "results"
        )

        self.externalIDs = try container
            .decodeSocialLinkIDsIfPresent(forKey: .externalIDs)
            .map {
                TVSeriesExternalLinksCollection(
                    id: id,
                    imdb: IMDbLink(imdbTitleID: $0.imdbID),
                    wikiData: WikiDataLink(wikiDataID: $0.wikiDataID),
                    facebook: FacebookLink(facebookID: $0.facebookID),
                    instagram: InstagramLink(instagramID: $0.instagramID),
                    twitter: TwitterLink(twitterID: $0.twitterID)
                )
            }
    }

}
