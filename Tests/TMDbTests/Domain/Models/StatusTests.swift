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

}
