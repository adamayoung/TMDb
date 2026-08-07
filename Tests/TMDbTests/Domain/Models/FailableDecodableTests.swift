//
//  FailableDecodableTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct FailableDecodableTests {

    private struct Item: Decodable, Equatable {
        let id: Int
        let name: String
    }

    @Test("decodes a valid element")
    func decodesValidElement() throws {
        let data = Data(#"{"id": 1, "name": "one"}"#.utf8)

        let result = try JSONDecoder().decode(FailableDecodable<Item>.self, from: data)

        #expect(result.value == Item(id: 1, name: "one"))
    }

    @Test("yields nil for an element that cannot be decoded, without throwing")
    func yieldsNilForUndecodableElement() throws {
        let data = Data(#"{"id": "not-an-int"}"#.utf8)

        let result = try JSONDecoder().decode(FailableDecodable<Item>.self, from: data)

        #expect(result.value == nil)
    }

    @Test("a bad element is consumed so the rest of the array still decodes")
    func badElementDoesNotDropTheArray() throws {
        let data = Data(#"""
        [{"id": 1, "name": "one"}, {"nope": true}, {"id": 3, "name": "three"}]
        """#.utf8)

        let wrapped = try JSONDecoder().decode([FailableDecodable<Item>].self, from: data)
        let items = wrapped.compactMap(\.value)

        #expect(wrapped.count == 3)
        #expect(items == [Item(id: 1, name: "one"), Item(id: 3, name: "three")])
    }

}
