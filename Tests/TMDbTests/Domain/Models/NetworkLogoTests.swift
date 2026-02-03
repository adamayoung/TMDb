//
//  NetworkLogoTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct NetworkLogoTests {

    @Test("JSON decoding of NetworkLogo")
    func decodeReturnsNetworkLogo() throws {
        let expectedResult = try networkLogo()

        let result = try JSONDecoder.theMovieDatabase.decode(
            NetworkLogo.self,
            fromResource: "network-logo"
        )

        #expect(result == expectedResult)
    }

}

extension NetworkLogoTests {

    private func networkLogo() throws -> NetworkLogo {
        try NetworkLogo(
            filePath: #require(URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png")),
            aspectRatio: 3.73134328358209
        )
    }

}
