//
//  MediaListItemStatusTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct MediaListItemStatusTests {

    @Test("JSON decoding when item is present", .tags(.decoding))
    func decodeReturnsMediaListItemStatusWhenItemIsPresent() throws {
        let json = """
        {
          "id": "1",
          "itemPresent": true
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(
            MediaListItemStatus.self,
            from: data
        )

        #expect(result.id == "1")
        #expect(result.isPresent == true)
    }

    @Test("JSON decoding when item is not present", .tags(.decoding))
    func decodeReturnsMediaListItemStatusWhenItemIsNotPresent() throws {
        let json = """
        {
          "id": "123",
          "itemPresent": false
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(
            MediaListItemStatus.self,
            from: data
        )

        #expect(result.id == "123")
        #expect(result.isPresent == false)
    }

}
