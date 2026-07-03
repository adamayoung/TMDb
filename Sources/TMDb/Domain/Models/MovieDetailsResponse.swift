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

    // swiftlint:disable:next function_body_length
    public init(from decoder: Decoder) throws {
        self.movie = try Movie(from: decoder)
        let id = movie.id

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.credits = try container
            .decodeCastAndCrewIfPresent(CastMember.self, CrewMember.self, forKey: .credits)
            .map { ShowCredits(id: id, cast: $0.cast, crew: $0.crew) }

        self.images = try ImageCollection(from: container, forKey: .images, id: id)

        self.videos = try container
            .decodeNestedArrayIfPresent(VideoMetadata.self, forKey: .videos, nestedKey: "results")
            .map { VideoCollection(id: id, results: $0) }

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

        self.releaseDates = try container.decodeNestedIfPresent(
            [MovieReleaseDatesByCountry].self, forKey: .releaseDates, nestedKey: "results"
        )
        self.alternativeTitles = try container.decodeNestedIfPresent(
            [AlternativeTitle].self, forKey: .alternativeTitles, nestedKey: "titles"
        )
        self.translations = try container.decodeNestedIfPresent(
            [Translation<MovieTranslationData>].self, forKey: .translations, nestedKey: "translations"
        )
        self.keywords = try container.decodeNestedIfPresent(
            [Keyword].self, forKey: .keywords, nestedKey: "keywords"
        )
        self.watchProviders = try container.decodeNestedIfPresent(
            [String: ShowWatchProvider].self, forKey: .watchProviders, nestedKey: "results"
        )

        self.externalIDs = try SocialLinkIDs(from: container, forKey: .externalIDs)
            .map {
                MovieExternalLinksCollection(
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
