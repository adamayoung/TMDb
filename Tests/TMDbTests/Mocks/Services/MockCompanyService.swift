@testable import TMDb
import XCTest

final class MockCompanyService: CompanyService {

    var company: Company?

    func details(forCompany id: Company.ID) async throws -> Company {
        try await withCheckedThrowingContinuation { continuation in
            guard let company = company else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: company)
        }
    }

}
