//
//  TVSeriesDetailsResponse.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

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

    private enum CreditsCodingKeys: String, CodingKey {
        case cast
        case crew
    }

    private enum ImagesCodingKeys: String, CodingKey {
        case backdrops
        case logos
        case posters
    }

    private enum VideosCodingKeys: String, CodingKey {
        case results
    }

    private enum ResultsCodingKeys: String, CodingKey {
        case results
    }

    private enum TranslationsCodingKeys: String, CodingKey {
        case translations
    }

    private enum ExternalIDsCodingKeys: String, CodingKey {
        case imdbID = "imdbId"
        case wikiDataID = "wikidataId"
        case facebookID = "facebookId"
        case instagramID = "instagramId"
        case twitterID = "twitterId"
    }

    // swiftlint:disable function_body_length cyclomatic_complexity
    public init(from decoder: Decoder) throws {
        self.tvSeries = try TVSeries(from: decoder)

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
                id: tvSeries.id, cast: cast, crew: crew
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
            self.aggregateCredits = TVSeriesAggregateCredits(
                id: tvSeries.id, cast: cast, crew: crew
            )
        } else {
            self.aggregateCredits = nil
        }

        if container.contains(.images) {
            let nested = try container.nestedContainer(
                keyedBy: ImagesCodingKeys.self,
                forKey: .images
            )
            let backdrops = try nested.decodeIfPresent(
                [ImageMetadata].self, forKey: .backdrops
            ) ?? []
            let logos = try nested.decodeIfPresent(
                [ImageMetadata].self, forKey: .logos
            ) ?? []
            let posters = try nested.decodeIfPresent(
                [ImageMetadata].self, forKey: .posters
            ) ?? []
            self.images = ImageCollection(
                id: tvSeries.id,
                posters: posters,
                logos: logos,
                backdrops: backdrops
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
                id: tvSeries.id, results: results
            )
        } else {
            self.videos = nil
        }

        self.reviews = try container.decodeIfPresent(
            ReviewPageableList.self, forKey: .reviews
        )
        self.recommendations = try container.decodeIfPresent(
            TVSeriesPageableList.self,
            forKey: .recommendations
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

        if container.contains(.contentRatings) {
            let nested = try container.nestedContainer(
                keyedBy: ResultsCodingKeys.self,
                forKey: .contentRatings
            )
            self.contentRatings = try nested.decodeIfPresent(
                [ContentRating].self, forKey: .results
            )
        } else {
            self.contentRatings = nil
        }

        if container.contains(.alternativeTitles) {
            let nested = try container.nestedContainer(
                keyedBy: ResultsCodingKeys.self,
                forKey: .alternativeTitles
            )
            self.alternativeTitles = try nested.decodeIfPresent(
                [AlternativeTitle].self, forKey: .results
            )
        } else {
            self.alternativeTitles = nil
        }

        if container.contains(.translations) {
            let nested = try container.nestedContainer(
                keyedBy: TranslationsCodingKeys.self,
                forKey: .translations
            )
            self.translations = try nested.decodeIfPresent(
                [Translation<TVSeriesTranslationData>].self,
                forKey: .translations
            )
        } else {
            self.translations = nil
        }

        if container.contains(.keywords) {
            let nested = try container.nestedContainer(
                keyedBy: ResultsCodingKeys.self,
                forKey: .keywords
            )
            self.keywords = try nested.decodeIfPresent(
                [Keyword].self, forKey: .results
            )
        } else {
            self.keywords = nil
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

        if container.contains(.screenedTheatrically) {
            let nested = try container.nestedContainer(
                keyedBy: ResultsCodingKeys.self,
                forKey: .screenedTheatrically
            )
            self.screenedTheatrically =
                try nested.decodeIfPresent(
                    [ScreenedTheatricallyResult].self,
                    forKey: .results
                )
        } else {
            self.screenedTheatrically = nil
        }

        if container.contains(.episodeGroups) {
            let nested = try container.nestedContainer(
                keyedBy: ResultsCodingKeys.self,
                forKey: .episodeGroups
            )
            self.episodeGroups = try nested.decodeIfPresent(
                [TVEpisodeGroup].self, forKey: .results
            )
        } else {
            self.episodeGroups = nil
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
            let facebookID = try nested.decodeIfPresent(
                String.self, forKey: .facebookID
            )
            let instagramID = try nested.decodeIfPresent(
                String.self, forKey: .instagramID
            )
            let twitterID = try nested.decodeIfPresent(
                String.self, forKey: .twitterID
            )
            self.externalIDs = TVSeriesExternalLinksCollection(
                id: tvSeries.id,
                imdb: IMDbLink(imdbTitleID: imdbID),
                wikiData: WikiDataLink(
                    wikiDataID: wikiDataID
                ),
                facebook: FacebookLink(
                    facebookID: facebookID
                ),
                instagram: InstagramLink(
                    instagramID: instagramID
                ),
                twitter: TwitterLink(twitterID: twitterID)
            )
        } else {
            self.externalIDs = nil
        }
    }
    // swiftlint:enable function_body_length cyclomatic_complexity

}
