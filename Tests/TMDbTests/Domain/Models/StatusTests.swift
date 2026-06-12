//
//  StatusTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct StatusTests {

    @Test("rumored status returns raw value of Rumored")
    func rumoredStatusReturnsRawValue() {
        #expect(Status.rumoured.rawValue == "Rumored")
    }

    @Test("planned status returns raw value of Planned")
    func plannedStatusReturnsRawValue() {
        #expect(Status.planned.rawValue == "Planned")
    }

    @Test("inProduction status returns raw value of In Production")
    func inProductionStatusReturnsRawValue() {
        #expect(Status.inProduction.rawValue == "In Production")
    }

    @Test("postProduction status returns raw value of Post Production")
    func postProductionStatusReturnsRawValue() {
        #expect(Status.postProduction.rawValue == "Post Production")
    }

    @Test("released status returns raw value of Released")
    func releasedStatusReturnsRawValue() {
        #expect(Status.released.rawValue == "Released")
    }

    @Test("cancled status returns raw value of Cancled")
    func canceledStatusReturnsRawValue() {
        #expect(Status.cancelled.rawValue == "Canceled")
    }

    @Test("JSON decoding of a known status", .tags(.decoding))
    func decodeWhenKnownValueReturnsStatus() throws {
        let data = Data("{\"status\": \"Released\"}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).status

        #expect(result == .released)
    }

    @Test("JSON decoding of an unknown status returns unknown", .tags(.decoding))
    func decodeWhenInvalidValueReturnsUnknown() throws {
        let data = Data("{\"status\": \"some-new-status\"}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).status

        #expect(result == .unknown)
    }

}

extension StatusTests {

    private struct MockObject: Decodable {
        let status: Status
    }

}
