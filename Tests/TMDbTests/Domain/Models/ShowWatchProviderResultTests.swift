//
//  ShowWatchProviderResultTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct ShowWatchProviderResultTests {

    /// `results` is an object keyed by ISO-3166-1 country code, not an array —
    /// the fixture this replaces encoded it as a Swift dictionary literal inside
    /// an array, so it could never have decoded and nothing ever read it.
    @Test("JSON decoding of ShowWatchProviderResult keyed by country code")
    func decodeReturnsShowWatchProviderResult() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowWatchProviderResult.self,
            fromResource: "show-watch-provider-result"
        )

        #expect(result.id == 1396)
        #expect(Set(result.results.keys) == ["JP", "NZ", "RU"])

        // Japan carries four of the five categories at once; `ads` appears
        // only on Russia below, which is why both regions are in the fixture.
        let japan = try #require(result.results["JP"])
        #expect(japan.link == URL(string: "https://www.themoviedb.org/tv/1396-breaking-bad/watch?locale=JP"))
        #expect(japan.buy?.map(\.name) == ["Amazon Video"])
        #expect(japan.free?.map(\.name) == ["Amazon Prime Video"])
        #expect(japan.rent?.map(\.name) == ["FOD"])
        #expect(japan.flatRate?.map(\.name) == ["Netflix"])
        #expect(japan.ads == nil)

        // Russia carries only `ads`; every other category must decode as nil
        // rather than as an empty array.
        let russia = try #require(result.results["RU"])
        #expect(russia.ads?.map(\.name) == ["TvIgle"])
        #expect(russia.buy == nil)
        #expect(russia.free == nil)
        #expect(russia.rent == nil)
        #expect(russia.flatRate == nil)

        let newZealand = try #require(result.results["NZ"])
        let neon = try #require(newZealand.flatRate?.first)
        #expect(neon.id == 273)
        #expect(neon.name == "Neon TV")
    }

}
