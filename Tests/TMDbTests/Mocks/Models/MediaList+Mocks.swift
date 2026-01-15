//
//  MediaList+Mocks.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
import TMDb

extension MediaList {

    static func mock(
        id: Int = 1,
        name: String = "The Marvel Universe",
        description: String? =
            "The idea behind this list is to collect the live action comic book movies from within the Marvel franchise.",
        createdBy: String = "Travis Bell",
        iso6391: String = "en",
        itemCount: Int = 69,
        favoriteCount: Int = 0,
        posterPath: URL? = URL(string: "/coJVIUEOToAEGViuhclM7pXC75R.jpg"),
        items: [MediaListItem] = [],
        page: Int? = 1,
        totalPages: Int? = 4,
        totalResults: Int? = 69
    ) -> MediaList {
        MediaList(
            id: id,
            name: name,
            description: description,
            createdBy: createdBy,
            iso6391: iso6391,
            itemCount: itemCount,
            favoriteCount: favoriteCount,
            posterPath: posterPath,
            items: items,
            page: page,
            totalPages: totalPages,
            totalResults: totalResults
        )
    }

}
