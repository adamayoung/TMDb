//
//  PersonDetailsResponse.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A person details response with optional appended data.
///
/// Use with ``PersonService/details(forPerson:appending:language:)``
/// to fetch person details and related data in a single request.
///
public struct PersonDetailsResponse: Equatable, Hashable,
Sendable {

    ///
    /// The person details.
    ///
    public let person: Person

    ///
    /// Movie credits.
    ///
    public let movieCredits: PersonMovieCredits?

    ///
    /// TV series credits.
    ///
    public let tvCredits: PersonTVSeriesCredits?

    ///
    /// Combined movie and TV credits.
    ///
    public let combinedCredits: PersonCombinedCredits?

    ///
    /// Image collection.
    ///
    public let images: PersonImageCollection?

    ///
    /// Tagged images.
    ///
    public let taggedImages: TaggedImagePageableList?

    ///
    /// Translations.
    ///
    public let translations: [Translation<PersonTranslationData>]?

    ///
    /// External IDs and links.
    ///
    public let externalIDs: PersonExternalLinksCollection?

    ///
    /// Change history.
    ///
    public let changes: ChangeCollection?

    ///
    /// Creates a person details response.
    ///
    /// - Parameters:
    ///   - person: The person details.
    ///   - movieCredits: Movie credits.
    ///   - tvCredits: TV series credits.
    ///   - combinedCredits: Combined credits.
    ///   - images: Image collection.
    ///   - taggedImages: Tagged images.
    ///   - translations: Translations.
    ///   - externalIDs: External IDs and links.
    ///   - changes: Change history.
    ///
    public init(
        person: Person,
        movieCredits: PersonMovieCredits? = nil,
        tvCredits: PersonTVSeriesCredits? = nil,
        combinedCredits: PersonCombinedCredits? = nil,
        images: PersonImageCollection? = nil,
        taggedImages: TaggedImagePageableList? = nil,
        translations: [Translation<PersonTranslationData>]? = nil,
        externalIDs: PersonExternalLinksCollection? = nil,
        changes: ChangeCollection? = nil
    ) {
        self.person = person
        self.movieCredits = movieCredits
        self.tvCredits = tvCredits
        self.combinedCredits = combinedCredits
        self.images = images
        self.taggedImages = taggedImages
        self.translations = translations
        self.externalIDs = externalIDs
        self.changes = changes
    }

}

extension PersonDetailsResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case movieCredits
        case tvCredits
        case combinedCredits
        case images
        case taggedImages
        case translations
        case externalIDs = "externalIds"
        case changes
    }

    public init(from decoder: Decoder) throws {
        self.person = try Person(from: decoder)
        let id = person.id

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.movieCredits = try container
            .decodeCastAndCrewIfPresent(
                MovieCastCredit.self, MovieCrewCredit.self, forKey: .movieCredits
            )
            .map { PersonMovieCredits(id: id, cast: $0.cast, crew: $0.crew) }

        self.tvCredits = try container
            .decodeCastAndCrewIfPresent(
                TVSeriesCastCredit.self, TVSeriesCrewCredit.self, forKey: .tvCredits
            )
            .map { PersonTVSeriesCredits(id: id, cast: $0.cast, crew: $0.crew) }

        self.combinedCredits = try container
            .decodeCastAndCrewIfPresent(
                ShowCastCredit.self, ShowCrewCredit.self, forKey: .combinedCredits
            )
            .map { PersonCombinedCredits(id: id, cast: $0.cast, crew: $0.crew) }

        self.images = try container
            .decodeNestedArrayIfPresent(ImageMetadata.self, forKey: .images, nestedKey: "profiles")
            .map { PersonImageCollection(id: id, profiles: $0) }

        self.taggedImages = try container.decodeIfPresent(
            TaggedImagePageableList.self,
            forKey: .taggedImages
        )
        self.changes = try container.decodeIfPresent(
            ChangeCollection.self, forKey: .changes
        )

        self.translations = try container.decodeNestedIfPresent(
            [Translation<PersonTranslationData>].self,
            forKey: .translations,
            nestedKey: "translations"
        )

        self.externalIDs = try container
            .decodeSocialLinkIDsIfPresent(forKey: .externalIDs)
            .map {
                PersonExternalLinksCollection(
                    id: id,
                    imdb: IMDbLink(imdbNameID: $0.imdbID),
                    wikiData: WikiDataLink(wikiDataID: $0.wikiDataID),
                    facebook: FacebookLink(facebookID: $0.facebookID),
                    instagram: InstagramLink(instagramID: $0.instagramID),
                    twitter: TwitterLink(twitterID: $0.twitterID),
                    tikTok: TikTokLink(tikTokID: $0.tikTokID)
                )
            }
    }

}
