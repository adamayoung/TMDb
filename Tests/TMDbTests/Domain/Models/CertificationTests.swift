//
//  CertificationTests.swift
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
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct CertificationTests {

    @Test("ID and code matches")
    func idReturnsCode() {
        #expect(certification.id == certification.code)
    }

    @Test("JSON decoding of Certification", .tags(.decoding))
    func decodeCertification() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Certification.self, fromResource: "certification")

        #expect(result.code == certification.code)
        #expect(result.meaning == certification.meaning)
        #expect(result.order == certification.order)
    }

    private let certification = Certification(
        code: "15",
        meaning:
            "Only those over 15 years are admitted. Nobody younger than 15 can rent or buy a 15-rated VHS, DVD, Blu-ray Disc, UMD or game, or watch a film in the cinema with this rating. Films under this category can contain adult themes, hard drugs, frequent strong language and limited use of very strong language, strong violence and strong sex references, and nudity without graphic detail. Sexual activity may be portrayed but without any strong detail. Sexual violence may be shown if discreet and justified by context.",
        order: 5
    )

}
