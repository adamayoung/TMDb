//
//  CreateListResultTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CreateListResultTests {

    @Test("JSON decoding of successful result", .tags(.decoding))
    func decodeReturnsCreateListResultWhenSuccessful() throws {
        let json = """
        {
          "success": true,
          "status_message": "The item/record was created successfully.",
          "status_code": 1,
          "listId": 12345
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(CreateListResult.self, from: data)

        #expect(result.success == true)
        #expect(result.statusMessage == "The item/record was created successfully.")
        #expect(result.statusCode == 1)
        #expect(result.listID == 12345)
    }

    @Test("JSON decoding of failed result", .tags(.decoding))
    func decodeReturnsCreateListResultWhenFailed() throws {
        let json = """
        {
          "success": false,
          "status_message": "Invalid API key",
          "status_code": 7,
          "listId": 0
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(CreateListResult.self, from: data)

        #expect(result.success == false)
        #expect(result.statusMessage == "Invalid API key")
        #expect(result.statusCode == 7)
        #expect(result.listID == 0)
    }

}
