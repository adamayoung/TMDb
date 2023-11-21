//
//  StatusTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class StatusTests: XCTestCase {

    func testRumoredStatusReturnsRawValue() {
        XCTAssertEqual(Status.rumoured.rawValue, "Rumored")
    }

    func testPlannedStatusReturnsRawValue() {
        XCTAssertEqual(Status.planned.rawValue, "Planned")
    }

    func testInProductionStatusReturnsRawValue() {
        XCTAssertEqual(Status.inProduction.rawValue, "In Production")
    }

    func testPostProductionStatusReturnsRawValue() {
        XCTAssertEqual(Status.postProduction.rawValue, "Post Production")
    }

    func testReleasedStatusReturnsRawValue() {
        XCTAssertEqual(Status.released.rawValue, "Released")
    }

    func testCanceledStatusReturnsRawValue() {
        XCTAssertEqual(Status.cancelled.rawValue, "Canceled")
    }

}
