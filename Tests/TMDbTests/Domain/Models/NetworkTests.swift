//
//  NetworkTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct NetworkTests {

    @Test("JSON decoding of Network", .tags(.decoding))
    func decodeReturnsNetwork() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Network.self, fromResource: "network")

        #expect(result.id == network.id)
        #expect(result.name == network.name)
        #expect(result.logoPath == network.logoPath)
        #expect(result.originCountry == network.originCountry)
    }

    private let network = Network(
        id: 49,
        name: "HBO",
        logoPath: URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png"),
        originCountry: "US"
    )

}
