//
//  CollectionListItem+Mock.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
