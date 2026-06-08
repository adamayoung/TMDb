//
//  ImageSizeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ImageSizeTests {

    @Test("pathComponent for width returns w-prefixed component")
    func pathComponentForWidthReturnsWidthComponent() {
        #expect(ImageSize.width(500).pathComponent == "w500")
    }

    @Test("pathComponent for height returns h-prefixed component")
    func pathComponentForHeightReturnsHeightComponent() {
        #expect(ImageSize.height(300).pathComponent == "h300")
    }

    @Test("pathComponent for original returns original")
    func pathComponentForOriginalReturnsOriginal() {
        #expect(ImageSize.original.pathComponent == "original")
    }

    @Test("decodes from path component string")
    func decodesFromPathComponentString() throws {
        let data = Data("[\"w500\",\"h632\",\"original\"]".utf8)

        let result = try JSONDecoder().decode([ImageSize].self, from: data)

        #expect(result == [.width(500), .height(632), .original])
    }

    @Test("encodes to path component string")
    func encodesToPathComponentString() throws {
        let sizes: [ImageSize] = [.width(500), .height(632), .original]

        let data = try JSONEncoder().encode(sizes)
        let result = try #require(String(data: data, encoding: .utf8))

        #expect(result == "[\"w500\",\"h632\",\"original\"]")
    }

    @Test("decoding an invalid value throws")
    func decodingInvalidValueThrows() {
        let data = Data("[\"x500\"]".utf8)

        #expect(throws: DecodingError.self) {
            _ = try JSONDecoder().decode([ImageSize].self, from: data)
        }
    }

    @Test("init from canonical path component returns size")
    func initFromCanonicalPathComponentReturnsSize() {
        #expect(ImageSize(pathComponent: "w500") == .width(500))
        #expect(ImageSize(pathComponent: "h300") == .height(300))
        #expect(ImageSize(pathComponent: "original") == .original)
    }

    @Test(
        "init from non-canonical or invalid path component returns nil",
        arguments: ["w007", "w-500", "w0", "w+5", "h007", "h-300", "h0", "h+5"]
    )
    func initFromNonCanonicalPathComponentReturnsNil(pathComponent: String) {
        #expect(ImageSize(pathComponent: pathComponent) == nil)
    }

}
