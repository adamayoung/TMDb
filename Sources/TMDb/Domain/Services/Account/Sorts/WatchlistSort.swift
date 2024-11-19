//
//  WatchlistSort.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
