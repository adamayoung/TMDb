//
//  XCTestManifests.swift
//  TMDbClientTests
//
//  Created by Adam Young on 30/03/2020.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(TMDbAPIClientTests.allTests)
  ]
}
#endif
