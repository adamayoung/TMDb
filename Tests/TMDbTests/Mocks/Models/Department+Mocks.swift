//
//  Department+Mocks.swift
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
import TMDb

extension Department {

    static func mock(
        name: String = .randomString,
        jobs: [String] = [.randomString, .randomString]
    ) -> Self {
        .init(
            name: name,
            jobs: jobs
        )
    }

    static var costumeAndMakeUp: Self {
        .mock(
            name: "Costume & Make-Up",
            jobs: [
                "Set Costumer",
                "Co-Costume Designer"
            ]
        )
    }

    static var production: Self {
        .mock(
            name: "Production",
            jobs: [
                "Casting",
                "ADR Voice Casting",
                "Production Accountant"
            ]
        )
    }

}

extension [Department] {

    static var mocks: [Department] {
        [.costumeAndMakeUp, .production]
    }

}
