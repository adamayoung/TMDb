//
//  DepartmentTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class DepartmentTests: XCTestCase {

    func testDecodeReturnsDepartment() throws {
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

        let result = try JSONDecoder.theMovieDatabase.decode(Department.self,
                                                             fromResource: "configuration-jobs-by-department")

        XCTAssertEqual(result.id, expectedResult.name)
        XCTAssertEqual(result.name, expectedResult.name)
        XCTAssertEqual(result.jobs, expectedResult.jobs)
    }

}
