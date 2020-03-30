//
//  LinuxMain.swift
//  TMDbTests
//
//  Created by Adam Young on 24/01/2020.
//

import TMDbClientTests
import TMDbConfigurationTests
import TMDbCreditsTests
import TMDbImagesTests
import TMDbMoviesTests
import TMDbPeopleTests
import TMDbReviewsTests
import TMDbTVShowsTests
import TMDbVideosTests
import XCTest

var tests = [XCTestCaseEntry]()
tests += TMDbClientTests.allTests()
tests += TMDbConfigurationTests.allTests()
tests += TMDbCreditsTests.allTests()
tests += TMDbImagesTests.allTests()
tests += TMDbMoviesTests.allTests()
tests += TMDbPeopleTests.allTests()
tests += TMDbReviewsTests.allTests()
tests += TMDbTVShowsTests.allTests()
tests += TMDbVideosTests.allTests()
XCTMain(tests)
