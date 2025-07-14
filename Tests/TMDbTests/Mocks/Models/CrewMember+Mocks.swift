//
//  CrewMember+Mocks.swift
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
import TMDb

extension CrewMember {

    static func mock(
        id: Int = 1,
        creditID: String = "2",
        name: String = "Crew Name",
        job: String = "Job Name",
        department: String = "Department Name",
        gender: Gender? = Gender.male,
        profilePath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
    ) -> CrewMember {
        CrewMember(
            id: id,
            creditID: creditID,
            name: name,
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
