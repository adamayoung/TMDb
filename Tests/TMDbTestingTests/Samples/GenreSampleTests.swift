//
//  GenreSampleTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

@Suite(.tags(.testingSupport, .samples, .genre))
struct GenreSampleTests {

    @Test("Genre.sample is non-degenerate")
    func sampleIsNonDegenerate() {
        let genre = Genre.sample

        #expect(genre.id != 0)
        #expect(!genre.name.isEmpty)
    }

    @Test("[Genre].samples is non-empty and non-degenerate")
    func samplesAreNonDegenerate() {
        let genres = [Genre].samples

        #expect(!genres.isEmpty)
        #expect(genres.allSatisfy { $0.id != 0 })
        #expect(genres.allSatisfy { !$0.name.isEmpty })
    }

    @Test("Genre.sample round-trips through Codable")
    func sampleRoundTripsThroughCodable() throws {
        let genre = Genre.sample

        let data = try JSONEncoder().encode(genre)
        let decoded = try JSONDecoder().decode(Genre.self, from: data)

        #expect(decoded == genre)
    }

}
