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
        let data = Data("aaa".utf8)

        do {
            _ = try await serialiser.decode(MockObject.self, from: data)
        } catch {
            XCTAssertTrue(true)
            return
        }

        XCTFail("Expected decode error to be thrown")
    }

    func testDecodeWhenDataCanBeDecodedReturnsDecodedObject() async throws {
        let expectedResult = MockObject()
        let data = expectedResult.data

        let result = try await serialiser.decode(MockObject.self, from: data)

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
