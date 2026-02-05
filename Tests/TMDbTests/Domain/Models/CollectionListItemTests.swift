//
//  CollectionListItemTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CollectionListItemTests {

    @Test("JSON decoding of CollectionListItem", .tags(.decoding))
    func decodeReturnsCollectionListItem() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CollectionListItem.self, fromResource: "collection-list-item"
        )

        #expect(result == collection)
    }

    @Test(
        "JSON decoding of CollectionListItem with name/original_name keys",
        .tags(.decoding)
    )
    func decodeWithNameKeysReturnsCollectionListItem() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CollectionListItem.self,
            fromResource: "collection-list-item-name"
        )

        #expect(result.id == 10)
        #expect(result.title == "Star Wars Collection")
        #expect(result.originalTitle == "Star Wars Collection")
        #expect(result.originalLanguage == "en")
        #expect(result.overview == "An epic space opera franchise.")
        #expect(result.posterPath != nil)
        #expect(result.backdropPath != nil)
        #expect(result.isAdultOnly == false)
    }

}

extension CollectionListItemTests {

    private var collection: CollectionListItem {
        .init(
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
