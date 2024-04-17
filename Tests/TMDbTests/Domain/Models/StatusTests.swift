//
//  StatusTests.swift
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
