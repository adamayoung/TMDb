//
//  CrewMember+Mocks.swift
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

extension CrewMember {

    static func mock(
        id: Int = .randomID,
        creditID: String = .randomID,
        name: String? = nil,
        job: String = "Job \(String.randomString)",
        department: String = "Department \(String.randomString))",
        gender: Gender? = Gender.male,
        profilePath: URL? = .randomImagePath
    ) -> Self {
        .init(
            id: id,
            creditID: creditID,
            name: name ?? "Crew Member \(id)",
            job: job,
            department: department,
            gender: gender,
            profilePath: profilePath
        )
    }

}

extension [CrewMember] {

    static var mocks: [Element] {
        []
    }

}
