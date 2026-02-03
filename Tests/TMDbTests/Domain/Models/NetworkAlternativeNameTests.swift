//
//  NetworkAlternativeNameTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct NetworkAlternativeNameTests {

    @Test("JSON decoding of NetworkAlternativeName")
    func decodeReturnsNetworkAlternativeName() throws {
        let data = Data(
            """
            {
                "name": "HBO Network",
                "type": ""
            }
            """.utf8
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            NetworkAlternativeName.self,
            from: data
        )

        #expect(result == networkAlternativeName)
    }

}

extension NetworkAlternativeNameTests {

    private var networkAlternativeName: NetworkAlternativeName {
        NetworkAlternativeName(
            name: "HBO Network",
            type: ""
        )
    }

}
