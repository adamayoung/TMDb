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
        let result = try JSONDecoder.theMovieDatabase.decode(
            NetworkLogo.self,
            fromResource: "network-logo"
        )

        #expect(result == networkLogo)
    }

}

extension NetworkLogoTests {

    private var networkLogo: NetworkLogo {
        NetworkLogo(
            filePath: URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png")!,
            aspectRatio: 3.73134328358209
        )
    }

}
