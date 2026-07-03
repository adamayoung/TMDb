//
//  SocialLinkIDs.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The optional social-link identifiers decoded from an `external_ids` append section.
///
/// A shared intermediate that each `*ExternalLinksCollection` maps into its own
/// external-links type.
///
struct SocialLinkIDs {

    let imdbID: String?
    let wikiDataID: String?
    let facebookID: String?
    let instagramID: String?
    let twitterID: String?
    let tikTokID: String?

}

extension SocialLinkIDs {

    ///
    /// Decodes the social-link identifiers from the object at `key`.
    ///
    /// The `external_ids` append section is a flat object of optional identifier
    /// strings; this decodes every known identifier (each `nil` when absent).
    ///
    /// - Parameters:
    ///   - container: The container holding the `external_ids` wrapper.
    ///   - key: The wrapper key. When absent, the initializer returns `nil`.
    ///
    init?<Key: CodingKey>(
        from container: KeyedDecodingContainer<Key>,
        forKey key: Key
    ) throws {
        guard container.contains(key) else {
            return nil
        }

        let nested = try container.nestedContainer(keyedBy: StringCodingKey.self, forKey: key)

        func string(_ name: String) throws -> String? {
            try nested.decodeIfPresent(String.self, forKey: StringCodingKey(name))
        }

        try self.init(
            imdbID: string("imdbId"),
            wikiDataID: string("wikidataId"),
            facebookID: string("facebookId"),
            instagramID: string("instagramId"),
            twitterID: string("twitterId"),
            tikTokID: string("tiktokId")
        )
    }

}
