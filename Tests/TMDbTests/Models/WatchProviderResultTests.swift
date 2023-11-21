//
//  WatchProviderResultTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class WatchProviderResultTests: XCTestCase {

    func testDecodeReturnsWatchProviderResult() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(WatchProviderResult.self,
                                                             fromResource: "watch-provider-result")

        XCTAssertEqual(result, watchProviderResult)
    }

    private let watchProviderResult = WatchProviderResult(
        results: [
            .init(
                id: 8,
                name: "Netflix",
                logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!
            ),
            .init(
                id: 9,
                name: "Amazon Prime Video",
                logoPath: URL(string: "/emthp39XA2YScoYL1p0sdbAH2WA.jpg")!
            )
        ]
    )

}
