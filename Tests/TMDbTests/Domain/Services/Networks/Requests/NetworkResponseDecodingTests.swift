//
//  NetworkResponseDecodingTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

/// The element types (`NetworkAlternativeName`, `NetworkLogo`) were already
/// covered, but the response wrappers these two endpoints actually return were
/// not — the service tests build them directly against a mock API client and
/// never parse JSON.
@Suite(.tags(.models, .decoding))
struct NetworkResponseDecodingTests {

    @Test("JSON decoding of NetworkAlternativeNamesResponse")
    func decodeReturnsNetworkAlternativeNamesResponse() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            NetworkAlternativeNamesResponse.self,
            fromResource: "network-alternative-names"
        )

        #expect(result.id == 49)
        #expect(result.results.map(\.name) == ["HBO HD", "Home Box Office"])
        // TMDb sends an empty string rather than omitting the type.
        #expect(result.results.map(\.type) == ["", ""])
    }

    @Test("JSON decoding of NetworkLogosResponse")
    func decodeReturnsNetworkLogosResponse() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            NetworkLogosResponse.self,
            fromResource: "network-images"
        )

        #expect(result.id == 49)
        #expect(result.logos.count == 2)

        let logo = try #require(result.logos.first)
        #expect(logo.filePath == URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png"))
        #expect(logo.aspectRatio == 2.425_287_356_321_839)
    }

}
