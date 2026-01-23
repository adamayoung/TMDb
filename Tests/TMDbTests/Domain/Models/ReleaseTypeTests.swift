//
//  ReleaseTypeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct ReleaseTypeTests {

    @Test("premiere decodes from 1", .tags(.decoding))
    func premiereDecodesFrom1() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-1"
        )

        #expect(result == .premiere)
    }

    @Test("limited decodes from 2", .tags(.decoding))
    func limitedDecodesFrom2() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-2"
        )

        #expect(result == .limited)
    }

    @Test("theatrical decodes from 3", .tags(.decoding))
    func theatricalDecodesFrom3() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-3"
        )

        #expect(result == .theatrical)
    }

    @Test("digital decodes from 4", .tags(.decoding))
    func digitalDecodesFrom4() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-4"
        )

        #expect(result == .digital)
    }

    @Test("physical decodes from 5", .tags(.decoding))
    func physicalDecodesFrom5() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-5"
        )

        #expect(result == .physical)
    }

    @Test("tv decodes from 6", .tags(.decoding))
    func tvDecodesFrom6() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-6"
        )

        #expect(result == .tv)
    }

    @Test("unknown decodes from unsupported value", .tags(.decoding))
    func unknownDecodesFromUnsupportedValue() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-999"
        )

        #expect(result == .unknown)
    }

}
