@testable import TMDb
import XCTest

class DataFormatterTMDbTests: XCTestCase {

    func testTheMovieDatabaseFormatterHasCorrectDateFormat() {
        let expectedResult = "yyyy-MM-dd"

        let result = DateFormatter.theMovieDatabase.dateFormat

        XCTAssertEqual(result, expectedResult)
    }

}
