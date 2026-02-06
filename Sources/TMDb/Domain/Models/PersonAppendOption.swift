//
//  PersonAppendOption.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Options for data to append to a person details response.
///
/// Use these options with ``PersonService/details(forPerson:appending:language:)``
/// to fetch additional data in a single request.
///
/// ```swift
/// let result = try await client.people.details(
///     forPerson: 287,
///     appending: [.movieCredits, .images]
/// )
/// ```
///
public struct PersonAppendOption: OptionSet, Hashable, Sendable {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Append movie credits.
    public static let movieCredits = PersonAppendOption(rawValue: 1 << 0)

    /// Append TV series credits.
    public static let tvCredits = PersonAppendOption(rawValue: 1 << 1)

    /// Append combined movie and TV credits.
    public static let combinedCredits = PersonAppendOption(rawValue: 1 << 2)

    /// Append image collection.
    public static let images = PersonAppendOption(rawValue: 1 << 3)

    /// Append tagged images.
    public static let taggedImages = PersonAppendOption(rawValue: 1 << 4)

    /// Append translations.
    public static let translations = PersonAppendOption(rawValue: 1 << 5)

    /// Append external IDs.
    public static let externalIDs = PersonAppendOption(rawValue: 1 << 6)

    /// Append change history.
    public static let changes = PersonAppendOption(rawValue: 1 << 7)

}

extension PersonAppendOption {

    private static let mapping: [(PersonAppendOption, String)] = [
        (.movieCredits, "movie_credits"),
        (.tvCredits, "tv_credits"),
        (.combinedCredits, "combined_credits"),
        (.images, "images"),
        (.taggedImages, "tagged_images"),
        (.translations, "translations"),
        (.externalIDs, "external_ids"),
        (.changes, "changes")
    ]

    var queryValue: String {
        Self.mapping
            .filter { contains($0.0) }
            .map(\.1)
            .joined(separator: ",")
    }

}
