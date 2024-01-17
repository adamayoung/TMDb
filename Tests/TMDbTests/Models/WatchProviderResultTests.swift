//
//  WatchProviderResultTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@testable import TMDb
import XCTest

final class WatchProviderResultTests: XCTestCase {

    func testDecodeReturnsWatchProviderResult() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            WatchProviderResult.self,
            fromResource: "watch-provider-result"
        )

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
