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

    private enum CreditsCodingKeys: String, CodingKey {
        case cast
        case crew
    }

    private enum ImagesCodingKeys: String, CodingKey {
        case profiles
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
        case tikTokID = "tiktokId"
    }

    // swiftlint:disable function_body_length
    public init(from decoder: Decoder) throws {
        self.person = try Person(from: decoder)

        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        if container.contains(.movieCredits) {
            let nested = try container.nestedContainer(
                keyedBy: CreditsCodingKeys.self,
                forKey: .movieCredits
            )
            let cast = try nested.decodeIfPresent(
                [MovieCastCredit].self, forKey: .cast
            ) ?? []
            let crew = try nested.decodeIfPresent(
                [MovieCrewCredit].self, forKey: .crew
            ) ?? []
            self.movieCredits = PersonMovieCredits(
                id: person.id, cast: cast, crew: crew
            )
        } else {
            self.movieCredits = nil
        }

        if container.contains(.tvCredits) {
            let nested = try container.nestedContainer(
                keyedBy: CreditsCodingKeys.self,
                forKey: .tvCredits
            )
            let cast = try nested.decodeIfPresent(
                [TVSeriesCastCredit].self, forKey: .cast
            ) ?? []
            let crew = try nested.decodeIfPresent(
                [TVSeriesCrewCredit].self, forKey: .crew
            ) ?? []
            self.tvCredits = PersonTVSeriesCredits(
                id: person.id, cast: cast, crew: crew
            )
        } else {
            self.tvCredits = nil
        }

        if container.contains(.combinedCredits) {
            let nested = try container.nestedContainer(
                keyedBy: CreditsCodingKeys.self,
                forKey: .combinedCredits
            )
            let cast = try nested.decodeIfPresent(
                [ShowCastCredit].self, forKey: .cast
            ) ?? []
            let crew = try nested.decodeIfPresent(
                [ShowCrewCredit].self, forKey: .crew
            ) ?? []
            self.combinedCredits = PersonCombinedCredits(
                id: person.id, cast: cast, crew: crew
            )
        } else {
            self.combinedCredits = nil
        }

        if container.contains(.images) {
            let nested = try container.nestedContainer(
                keyedBy: ImagesCodingKeys.self,
                forKey: .images
            )
            let profiles = try nested.decodeIfPresent(
                [ImageMetadata].self, forKey: .profiles
            ) ?? []
            self.images = PersonImageCollection(
                id: person.id, profiles: profiles
            )
        } else {
            self.images = nil
        }

        self.taggedImages = try container.decodeIfPresent(
            TaggedImagePageableList.self,
            forKey: .taggedImages
        )
        self.changes = try container.decodeIfPresent(
            ChangeCollection.self, forKey: .changes
        )

        if container.contains(.translations) {
            let nested = try container.nestedContainer(
                keyedBy: TranslationsCodingKeys.self,
                forKey: .translations
            )
            self.translations = try nested.decodeIfPresent(
                [Translation<PersonTranslationData>].self,
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
            let facebookID = try nested.decodeIfPresent(
                String.self, forKey: .facebookID
            )
            let instagramID = try nested.decodeIfPresent(
                String.self, forKey: .instagramID
            )
            let twitterID = try nested.decodeIfPresent(
                String.self, forKey: .twitterID
            )
            let tikTokID = try nested.decodeIfPresent(
                String.self, forKey: .tikTokID
            )
            self.externalIDs = PersonExternalLinksCollection(
                id: person.id,
                imdb: IMDbLink(imdbNameID: imdbID),
                wikiData: WikiDataLink(
                    wikiDataID: wikiDataID
                ),
                facebook: FacebookLink(
                    facebookID: facebookID
                ),
                instagram: InstagramLink(
                    instagramID: instagramID
                ),
                twitter: TwitterLink(twitterID: twitterID),
                tikTok: TikTokLink(tikTokID: tikTokID)
            )
        } else {
            self.externalIDs = nil
        }
    }
    // swiftlint:enable function_body_length

}
