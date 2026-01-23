//
//  WatchlistSort.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A sort specifier when fetching movies.
///
public enum WatchlistSort: CustomStringConvertible {

    ///
    /// By created at.
    ///
    case createdAt(descending: Bool = false)

    ///
    /// A textual representation of this sort.
    ///
    public var description: String {
        "\(fieldName).\(isDescending ? "desc" : "asc")"
    }

}

extension WatchlistSort {

    private var fieldName: String {
        switch self {
        case .createdAt:
            "created_at"
        }
    }

    private var isDescending: Bool {
        switch self {
        case .createdAt(let descending):
            descending
        }
    }

}
