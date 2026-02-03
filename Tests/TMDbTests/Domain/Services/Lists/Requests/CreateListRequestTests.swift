//
//  CreateListRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .list))
struct CreateListRequestTests {

    @Test("path is correct")
    func path() {
        let request = CreateListRequest(
            name: "Test List",
            description: "Test description",
            language: "en",
            isPublic: true,
            sessionID: "abc123"
        )

        #expect(request.path == "/list")
    }

    @Test("queryItems contains session_id")
    func queryItemsContainsSessionID() {
        let request = CreateListRequest(
            name: "Test List",
            description: "Test description",
            language: "en",
            isPublic: true,
            sessionID: "abc123"
        )

        #expect(request.queryItems == ["session_id": "abc123"])
    }

    @Test("method is POST")
    func methodIsPost() {
        let request = CreateListRequest(
            name: "Test List",
            description: "Test description",
            language: "en",
            isPublic: true,
            sessionID: "abc123"
        )

        #expect(request.method == .post)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = CreateListRequest(
            name: "Test List",
            description: "Test description",
            language: "en",
            isPublic: true,
            sessionID: "abc123"
        )

        #expect(request.headers.isEmpty)
    }

    @Test("body contains all fields")
    func bodyContainsAllFields() throws {
        let request = CreateListRequest(
            name: "My List",
            description: "List description",
            language: "en",
            isPublic: true,
            sessionID: "abc123"
        )

        let body = try #require(request.body)

        #expect(body.name == "My List")
        #expect(body.description == "List description")
        #expect(body.language == "en")
        #expect(body.isPublic == true)
    }

    @Test("body contains name only when optional fields are nil")
    func bodyContainsNameOnlyWhenOptionalFieldsAreNil() throws {
        let request = CreateListRequest(
            name: "Simple List",
            description: nil,
            language: nil,
            isPublic: nil,
            sessionID: "abc123"
        )

        let body = try #require(request.body)

        #expect(body.name == "Simple List")
        #expect(body.description == nil)
        #expect(body.language == nil)
        #expect(body.isPublic == nil)
    }

    @Test("body encoding uses correct CodingKeys")
    func bodyEncodingUsesCorrectCodingKeys() throws {
        let bodyValue = CreateListRequest.Body(
            name: "Test",
            description: "Desc",
            language: "en",
            isPublic: false
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(bodyValue)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        #expect(json?["name"] as? String == "Test")
        #expect(json?["description"] as? String == "Desc")
        #expect(json?["iso6391"] as? String == "en")
        #expect(json?["public"] as? Bool == false)
    }

}
