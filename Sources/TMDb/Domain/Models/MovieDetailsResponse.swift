//
//  MovieDetailsResponse.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A movie details response with optional appended data.
///
/// Use with ``MovieService/details(forMovie:appending:language:)``
/// to fetch movie details and related data in a single request.
///
public struct MovieDetailsResponse: Equatable, Hashable, Sendable {

    ///
    /// The movie details.
    ///
    public let movie: Movie

    ///
    /// Cast and crew credits.
    ///
    public let credits: ShowCredits?

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
    /// Recommended movies.
    ///
    public let recommendations: MoviePageableList?

    ///
    /// Similar movies.
    ///
    public let similar: MoviePageableList?

    ///
    /// Release dates by country.
    ///
    public let releaseDates: [MovieReleaseDatesByCountry]?

    ///
    /// Alternative titles.
    ///
    public let alternativeTitles: [AlternativeTitle]?

    ///
    /// Translations.
    ///
    public let translations: [Translation<MovieTranslationData>]?

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
    public let externalIDs: MovieExternalLinksCollection?

    ///
    /// Lists containing this movie.
    ///
    public let lists: MediaListSummaryPageableList?

    ///
    /// Change history.
    ///
    public let changes: ChangeCollection?

    ///
    /// Creates a movie details response.
    ///
    /// - Parameters:
    ///   - movie: The movie details.
    ///   - credits: Cast and crew credits.
    ///   - images: Image collection.
    ///   - videos: Video collection.
    ///   - reviews: User reviews.
    ///   - recommendations: Recommended movies.
    ///   - similar: Similar movies.
    ///   - releaseDates: Release dates by country.
    ///   - alternativeTitles: Alternative titles.
    ///   - translations: Translations.
    ///   - keywords: Keywords.
    ///   - watchProviders: Watch providers by country code.
    ///   - externalIDs: External IDs and links.
    ///   - lists: Lists containing this movie.
    ///   - changes: Change history.
    ///
    public init(
        movie: Movie,
        credits: ShowCredits? = nil,
        images: ImageCollection? = nil,
        videos: VideoCollection? = nil,
        reviews: ReviewPageableList? = nil,
        recommendations: MoviePageableList? = nil,
        similar: MoviePageableList? = nil,
        releaseDates: [MovieReleaseDatesByCountry]? = nil,
        alternativeTitles: [AlternativeTitle]? = nil,
        translations: [Translation<MovieTranslationData>]? = nil,
        keywords: [Keyword]? = nil,
        watchProviders: [String: ShowWatchProvider]? = nil,
        externalIDs: MovieExternalLinksCollection? = nil,
        lists: MediaListSummaryPageableList? = nil,
        changes: ChangeCollection? = nil
    ) {
        self.movie = movie
        self.credits = credits
        self.images = images
        self.videos = videos
        self.reviews = reviews
        self.recommendations = recommendations
        self.similar = similar
        self.releaseDates = releaseDates
        self.alternativeTitles = alternativeTitles
        self.translations = translations
        self.keywords = keywords
        self.watchProviders = watchProviders
        self.externalIDs = externalIDs
        self.lists = lists
        self.changes = changes
    }

}

extension MovieDetailsResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case credits
        case images
        case videos
        case reviews
        case recommendations
        case similar
        case releaseDates
        case alternativeTitles
        case translations
        case keywords
        case watchProviders = "watch/providers"
        case externalIDs = "externalIds"
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

    private enum TitlesCodingKeys: String, CodingKey {
        case titles
    }

    private enum TranslationsCodingKeys: String, CodingKey {
        case translations
    }

    private enum MovieKeywordsCodingKeys: String, CodingKey {
        case keywords
    }

    private enum ExternalIDsCodingKeys: String, CodingKey {
        case imdbID = "imdbId"
        case wikiDataID = "wikidataId"
        case facebookID = "facebookId"
        case instagramID = "instagramId"
        case twitterID = "twitterId"
    }

    private enum WatchProvidersCodingKeys: String, CodingKey {
        case results
    }

    // swiftlint:disable function_body_length
    public init(from decoder: Decoder) throws {
        self.movie = try Movie(from: decoder)

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
                id: movie.id, cast: cast, crew: crew
            )
        } else {
            self.credits = nil
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
                id: movie.id,
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
                id: movie.id, results: results
            )
        } else {
            self.videos = nil
        }

        self.reviews = try container.decodeIfPresent(
            ReviewPageableList.self, forKey: .reviews
        )
        self.recommendations = try container.decodeIfPresent(
            MoviePageableList.self, forKey: .recommendations
        )
        self.similar = try container.decodeIfPresent(
            MoviePageableList.self, forKey: .similar
        )
        self.lists = try container.decodeIfPresent(
            MediaListSummaryPageableList.self, forKey: .lists
        )
        self.changes = try container.decodeIfPresent(
            ChangeCollection.self, forKey: .changes
        )

        if container.contains(.releaseDates) {
            let nested = try container.nestedContainer(
                keyedBy: ResultsCodingKeys.self,
                forKey: .releaseDates
            )
            self.releaseDates = try nested.decodeIfPresent(
                [MovieReleaseDatesByCountry].self,
                forKey: .results
            )
        } else {
            self.releaseDates = nil
        }

        if container.contains(.alternativeTitles) {
            let nested = try container.nestedContainer(
                keyedBy: TitlesCodingKeys.self,
                forKey: .alternativeTitles
            )
            self.alternativeTitles = try nested.decodeIfPresent(
                [AlternativeTitle].self, forKey: .titles
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
                [Translation<MovieTranslationData>].self,
                forKey: .translations
            )
        } else {
            self.translations = nil
        }

        if container.contains(.keywords) {
            let nested = try container.nestedContainer(
                keyedBy: MovieKeywordsCodingKeys.self,
                forKey: .keywords
            )
            self.keywords = try nested.decodeIfPresent(
                [Keyword].self, forKey: .keywords
            )
        } else {
            self.keywords = nil
        }

        if container.contains(.watchProviders) {
            let nested = try container.nestedContainer(
                keyedBy: WatchProvidersCodingKeys.self,
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
            self.externalIDs = MovieExternalLinksCollection(
                id: movie.id,
                imdb: IMDbLink(imdbTitleID: imdbID),
                wikiData: WikiDataLink(wikiDataID: wikiDataID),
                facebook: FacebookLink(facebookID: facebookID),
                instagram: InstagramLink(
                    instagramID: instagramID
                ),
                twitter: TwitterLink(twitterID: twitterID)
            )
        } else {
            self.externalIDs = nil
        }
    }
    // swiftlint:enable function_body_length

}
