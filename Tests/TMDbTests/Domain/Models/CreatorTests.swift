//
//  CreatorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct CreatorTests {

    @Test("id decodes correctly", .tags(.decoding))
    func iDDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.id == 9813)
    }

    @Test("creditID decodes correctly", .tags(.decoding))
    func creditIDDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.creditID == "5256c8c219c2956ff604858a")
    }

    @Test("name decodes correctly", .tags(.decoding))
    func nameDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.name == "David Benioff")
    }

    @Test("originalName decodes correctly", .tags(.decoding))
    func originalNameDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.originalName == "David Benioff")
    }

    @Test("gender decodes correctly", .tags(.decoding))
    func genderDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.gender == .male)
    }

    @Test("profilePath decodes correctly", .tags(.decoding))
    func profilePathDecodesCorrectly() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Creator.self, fromResource: "creator")

        #expect(result.profilePath == URL(string: "/xvNN5huL0X8yJ7h3IZfGG4O2zBD.jpg"))
    }

}
