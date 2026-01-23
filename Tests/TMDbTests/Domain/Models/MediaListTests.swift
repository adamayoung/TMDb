//
//  MediaListTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct MediaListTests {

    @Test("JSON decoding of MediaList", .tags(.decoding))
    func decodeReturnsMediaList() throws {
        let json = """
        {
          "created_by": "Travis Bell",
          "description": "The idea behind this list is to collect the live action comic book movies.",
          "favorite_count": 0,
          "id": 1,
          "iso_639_1": "en",
          "item_count": 69,
          "items": [],
          "name": "The Marvel Universe",
          "page": 1,
          "poster_path": "/coJVIUEOToAEGViuhclM7pXC75R.jpg",
          "total_pages": 4,
          "total_results": 69
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaList.self, from: data)

        #expect(result.id == 1)
        #expect(result.name == "The Marvel Universe")
        #expect(result.description != nil)
        #expect(result.createdBy == "Travis Bell")
        #expect(result.iso6391 == "en")
        #expect(result.itemCount == 69)
        #expect(result.favoriteCount == 0)
        #expect(result.posterPath?.absoluteString == "/coJVIUEOToAEGViuhclM7pXC75R.jpg")
        #expect(result.items.isEmpty)
        #expect(result.page == 1)
        #expect(result.totalPages == 4)
        #expect(result.totalResults == 69)
    }

}
