//
//  CertificationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
            Certification.self, fromResource: "certification"
        )

        #expect(result.code == certification.code)
        #expect(result.meaning == certification.meaning)
        #expect(result.order == certification.order)
    }

    // swiftlint:disable line_length
    private let certification = Certification(
        code: "15",
        meaning: "Only those over 15 years are admitted. Nobody younger than 15 can rent or buy a 15-rated VHS, DVD, Blu-ray Disc, UMD or game, or watch a film in the cinema with this rating. Films under this category can contain adult themes, hard drugs, frequent strong language and limited use of very strong language, strong violence and strong sex references, and nudity without graphic detail. Sexual activity may be portrayed but without any strong detail. Sexual violence may be shown if discreet and justified by context.",
        order: 5
    )
    // swiftlint:enable line_length

}
