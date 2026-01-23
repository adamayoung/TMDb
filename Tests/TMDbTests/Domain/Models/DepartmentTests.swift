//
//  DepartmentTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct DepartmentTests {

    @Test("JSON decoding of Department", .tags(.decoding))
    func decodeDepartment() throws {
        let expectedResult = Department(
            name: "Actors",
            jobs: [
                "Cameo",
                "Actor",
                "Voice",
                "Special Guest",
                "Stunt Double"
            ]
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            Department.self,
            fromResource: "configuration-jobs-by-department"
        )

        #expect(result.id == expectedResult.name)
        #expect(result.name == expectedResult.name)
        #expect(result.jobs == expectedResult.jobs)
    }

}
