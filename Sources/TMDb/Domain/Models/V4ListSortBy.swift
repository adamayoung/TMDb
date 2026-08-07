//
//  V4ListSortBy.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A sort order for the items in a v4 list.
///
/// Use it when creating or updating a list to set its stored order, and when
/// reading a list to override that order for one request.
///
/// - Note: These are the orderings TMDb accepts — each was confirmed against
///   the live API by setting it and reading the list back. Notably `popularity`,
///   `runtime`, `revenue`, `first_air_date` and `vote_count` are **rejected**,
///   even though the v3 discover endpoints accept several of them.
///
public enum V4ListSortBy: CustomStringConvertible, Equatable, Hashable, Sendable {

    ///
    /// By the order items were added to the list.
    ///
    /// This is the order a newly created list uses.
    ///
    case originalOrder(descending: Bool = false)

    ///
    /// By average vote.
    ///
    case voteAverage(descending: Bool = false)

    ///
    /// By primary release date.
    ///
    case primaryReleaseDate(descending: Bool = false)

    ///
    /// By release date.
    ///
    case releaseDate(descending: Bool = false)

    ///
    /// By title.
    ///
    case title(descending: Bool = false)

    ///
    /// The value as TMDb expects it, e.g. `title.asc`.
    ///
    public var description: String {
        "\(fieldName).\(isDescending ? "desc" : "asc")"
    }

}

extension V4ListSortBy {

    private var fieldName: String {
        switch self {
        case .originalOrder:
            "original_order"

        case .voteAverage:
            "vote_average"

        case .primaryReleaseDate:
            "primary_release_date"

        case .releaseDate:
            "release_date"

        case .title:
            "title"
        }
    }

    private var isDescending: Bool {
        switch self {
        case .originalOrder(let descending),
             .voteAverage(let descending),
             .primaryReleaseDate(let descending),
             .releaseDate(let descending),
             .title(let descending):
            descending
        }
    }

}
