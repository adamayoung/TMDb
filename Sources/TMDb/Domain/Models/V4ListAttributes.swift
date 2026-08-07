//
//  V4ListAttributes.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The settable properties of a v4 list.
///
/// Used when creating a list and when updating one. Every property is optional:
/// on create, an omitted property takes TMDb's default; on update, an omitted
/// property is left as it is.
///
public struct V4ListAttributes: Equatable, Hashable, Sendable {

    ///
    /// The list's name.
    ///
    public let name: String?

    ///
    /// The list's description.
    ///
    public let description: String?

    ///
    /// Whether the list is visible to everyone.
    ///
    /// - Note: TMDb defaults a new list to public.
    ///
    public let isPublic: Bool?

    ///
    /// ISO 639-1 language code for the list.
    ///
    public let languageCode: String?

    ///
    /// ISO 3166-1 country code for the list.
    ///
    public let countryCode: String?

    ///
    /// The order to store the list's items in.
    ///
    public let sortBy: V4ListSortBy?

    ///
    /// Creates a set of v4 list attributes.
    ///
    /// - Parameters:
    ///    - name: The list's name.
    ///    - description: The list's description.
    ///    - isPublic: Whether the list is visible to everyone.
    ///    - languageCode: ISO 639-1 language code for the list.
    ///    - countryCode: ISO 3166-1 country code for the list.
    ///    - sortBy: The order to store the list's items in.
    ///
    public init(
        name: String? = nil,
        description: String? = nil,
        isPublic: Bool? = nil,
        languageCode: String? = nil,
        countryCode: String? = nil,
        sortBy: V4ListSortBy? = nil
    ) {
        self.name = name
        self.description = description
        self.isPublic = isPublic
        self.languageCode = languageCode
        self.countryCode = countryCode
        self.sortBy = sortBy
    }

}
