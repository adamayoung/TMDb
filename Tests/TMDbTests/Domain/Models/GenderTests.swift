//
//  GenderTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct GenderTests {

    @Test("Unknown gender rawValue is 0")
    func unknownGenderRawValue() {
        #expect(Gender.unknown.rawValue == 0)
    }

    @Test("Female gender rawValue is 1")
    func femaleGenderRawValue() {
        #expect(Gender.female.rawValue == 1)
    }

    @Test("Male gender rawValue is 2")
    func maleGenderRawValue() {
        #expect(Gender.male.rawValue == 2)
    }

    @Test("Other gender rawValue is 3")
    func otherGenderRawValue() {
        #expect(Gender.other.rawValue == 3)
    }

    @Test("JSON decoding of invalid gender raw value", .tags(.decoding))
    func decodeInvalidValueReturnsUnknown() throws {
        let data = Data("{\"gender\": 9}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).gender

        #expect(result == .unknown)
    }

}

extension GenderTests {

    private struct MockObject: Decodable {
        let gender: Gender
    }

}
