//
//  CollectionListItem+Mocks.swift
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

@testable import TMDb

extension CollectionListItem {

    static func mock(
        id: Int = 999,
        title: String = "Collection",
        originalTitle: String = "Collection original",
        originalLanguage: String = "en",
        overview: String = "Collection overview",
        posterPath: URL? = URL(string: "/8sYdZSdgquS1iO4XzsGy9dN3DJ3.jpg"),
        backdropPath: URL? = nil,
        isAdultOnly: Bool = false
    ) -> CollectionListItem {
        CollectionListItem(
            id: id,
            title: title,
            originalTitle: originalTitle,
            originalLanguage: originalLanguage,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            isAdultOnly: isAdultOnly
        )
    }

    static var vinylAndTheVelvetUndergroundAndNico: CollectionListItem {
        .mock(
            id: 1_243_563,
            title: "Vinyl + The Velvet Underground & Nico",
            originalTitle: "Vinyl + The Velvet Underground & Nico",
            originalLanguage: "en",
            overview:
                "Vinyl (1965) 1h 10m\r The Velvet Underground and Nico: A Symphony of Sound (1966) 1h 10m",
            posterPath: URL(string: "/8sYdZSdgquS1iO4XzsGy9dN3DJ3.jpg"),
            backdropPath: nil,
            isAdultOnly: false
        )
    }

}
