@testable import TMDb
import XCTest

class DataFormatterTMDbTests: XCTestCase {

    func testTheMovieDatabaseFormatter_hasCorrectDateFormat() {
        let expectedResult = "yyyy-MM-dd"

        let result = DateFormatter.theMovieDatabase.dateFormat

        XCTAssertEqual(result, expectedResult)
    }

}
