@testable import TMDb
import XCTest

final class JSONDecoderTMDbTests: XCTestCase {

    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddd"
        return dateFormatter
    }

    func testTheMovieDatabaseDecoderDecodesObject() throws {
        let expectedResult = SomeThing(
            id: "abc123",
            firstName: "Adam",
            dateOfBirth: Self.dateFormatter.date(from: "1990-01-02")!
        )

        let jsonString = """
        {
            "id": "abc123",
            "first_name": "Adam",
            "date_of_birth": "1990-01-02"
        }
        """
        let data = Data(jsonString.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(SomeThing.self, from: data)

        XCTAssertEqual(result, expectedResult)
    }

    private struct SomeThing: Decodable, Equatable {

        let id: String
        let firstName: String
        let dateOfBirth: Date

    }

}
