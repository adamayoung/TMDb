//
//  ReleaseTypeTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct ReleaseTypeTests {

    @Test("premiere decodes from 1", .tags(.decoding))
    func premiereDecodesFrom1() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-1"
        )

        #expect(result == .premiere)
    }

    @Test("limited decodes from 2", .tags(.decoding))
    func limitedDecodesFrom2() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-2"
        )

        #expect(result == .limited)
    }

    @Test("theatrical decodes from 3", .tags(.decoding))
    func theatricalDecodesFrom3() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-3"
        )

        #expect(result == .theatrical)
    }

    @Test("digital decodes from 4", .tags(.decoding))
    func digitalDecodesFrom4() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-4"
        )

        #expect(result == .digital)
    }

    @Test("physical decodes from 5", .tags(.decoding))
    func physicalDecodesFrom5() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-5"
        )

        #expect(result == .physical)
    }

    @Test("tv decodes from 6", .tags(.decoding))
    func tvDecodesFrom6() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-6"
        )

        #expect(result == .tv)
    }

    @Test("unknown decodes from unsupported value", .tags(.decoding))
    func unknownDecodesFromUnsupportedValue() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseType.self,
            fromResource: "release-type-999"
        )

        #expect(result == .unknown)
    }

}
