@testable import TMDb
import XCTest

final class SerialiserTests: XCTestCase {

    var serialiser: Serialiser!

    override func setUp() {
        super.setUp()
        serialiser = Serialiser(decoder: JSONDecoder())
    }

    override func tearDown() {
        serialiser = nil
        super.tearDown()
    }

    func testDecodeWhenDataCannotBeDecodedThrowsDecodeError() async throws {
        let data = "aaa".data(using: .utf8)!

        do {
            _ = try await serialiser.decode(data) as MockObject
        } catch let error as TMDbError {
            switch error {
            case .decode:
                XCTAssertTrue(true)
                return
            default:
                break
            }
        }

        XCTFail("Expected decode error to be thrown")
    }

    func testDecodeWhenDataCanBeDecodedReturnsDecodedObject() async throws {
        let expectedResult = MockObject()
        let data = expectedResult.data

        let result = try await serialiser.decode(data) as MockObject

        XCTAssertEqual(result, expectedResult)
    }

}

extension SerialiserTests {

    private struct MockObject: Codable, Equatable {

        let id: UUID

        var data: Data {
            // swiftlint:disable force_try
            try! JSONEncoder().encode(self)
            // swiftlint:enable force_try
        }

        init(id: UUID = .init()) {
            self.id = id
        }
    }

}
