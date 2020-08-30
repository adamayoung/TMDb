import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TMDbAPIClientTests.allTests),

        testCase(TMDbConfigurationServiceTests.allTests),
        testCase(TMDbCreditsServiceTests.allTests),
        testCase(TMDbImageServiceTests.allTests),
        testCase(TMDbMovieServiceTests.allTests),
        testCase(TMDbPersonServiceTests.allTests),
        testCase(TMDbReviewServiceTests.allTests),
        testCase(TMDbTVShowServiceTests.allTests),
        testCase(TMDbVideoServiceTests.allTests)
    ]
}
#endif
