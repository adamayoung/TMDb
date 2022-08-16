@testable import TMDb
import XCTest

final class CompanyTests: XCTestCase {

    func testDecodeReturnsCompany() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Company.self, fromResource: "company")

        XCTAssertEqual(result.id, company.id)
        XCTAssertEqual(result.name, company.name)
        XCTAssertEqual(result.description, company.description)
        XCTAssertEqual(result.headquarters, company.headquarters)
        XCTAssertEqual(result.homepage, company.homepage)
        XCTAssertEqual(result.logoPath, company.logoPath)
        XCTAssertEqual(result.originCountry, company.originCountry)
        let parentCompany = try XCTUnwrap(result.parentCompany)
        XCTAssertEqual(parentCompany.id, company.parentCompany?.id)
        XCTAssertEqual(parentCompany.name, company.parentCompany?.name)
        XCTAssertEqual(parentCompany.logoPath, company.parentCompany?.logoPath)
    }

    private let company = Company(
        id: 3,
        name: "Pixar",
        description: "",
        headquarters: "Emeryville, California",
        homepage: URL(string: "http://www.pixar.com")!,
        logoPath: URL(string: "/1TjvGVDMYsj6JBxOAkUHpPEwLf7.png")!,
        originCountry: "US",
        parentCompany: Company.Parent(
            id: 2,
            name: "Walt Disney Pictures",
            logoPath: URL(string: "/wdrCwmRnLFJhEoH8GSfymY85KHT.png")!
        )
    )

}
