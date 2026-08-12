//
//  ShowTypeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ShowTypeTests {

    @Test("Movie show type rawValue is movie")
    func movieShowTypeRawValue() {
        #expect(ShowType.movie.rawValue == "movie")
    }

    @Test("TV series show type rawValue is tv")
    func tvSeriesShowTypeRawValue() {
        #expect(ShowType.tvSeries.rawValue == "tv")
    }

    @Test("JSON decoding of a movie show type", .tags(.decoding))
    func decodeMovie() throws {
        let data = Data(#""movie""#.utf8)

        let result = try JSONDecoder().decode(ShowType.self, from: data)

        #expect(result == .movie)
    }

    @Test("JSON decoding of a TV series show type", .tags(.decoding))
    func decodeTVSeries() throws {
        let data = Data(#""tv""#.utf8)

        let result = try JSONDecoder().decode(ShowType.self, from: data)

        #expect(result == .tvSeries)
    }

    @Test("JSON decoding of an unmodelled show type returns unknown", .tags(.decoding))
    func decodeUnmodelledShowTypeReturnsUnknown() throws {
        let data = Data(#""podcast""#.utf8)

        let result = try JSONDecoder().decode(ShowType.self, from: data)

        #expect(result == .unknown)
    }

    /// Pinned deliberately: ``ShowType/unknown`` is decode-only, but it still
    /// encodes to a real string rather than being suppressed. Anything sending a
    /// `ShowType` to TMDb must reject `.unknown` at the boundary instead of
    /// relying on the encoder to drop it.
    @Test("JSON encoding of an unknown show type", .tags(.encoding))
    func encodeUnknown() throws {
        let data = try JSONEncoder().encode(ShowType.unknown)
        let result = String(data: data, encoding: .utf8)

        #expect(result == #""unknown""#)
    }

}
