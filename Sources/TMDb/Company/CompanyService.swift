import Foundation
import os

///
/// Provides an interface for obtaining company data from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class CompanyService {

    private static let logger = Logger(subsystem: Logger.tmdb, category: "CompanyService")

    private let apiClient: APIClient

    ///
    /// Creates a company service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns a company's details
    ///
    /// [TMDb API - Companies: Details](https://developer.themoviedb.org/reference/company-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the company.
    ///
    /// - Returns: Matching company.
    ///
    public func details(forCompany id: Company.ID) async throws -> Company {
        Self.logger.info("fetching company \(id, privacy: .public)")

        let company: Company
        do {
            company = try await apiClient.get(endpoint: CompanyEndpoint.details(companyID: id))
        } catch let error {
            // swiftlint:disable:next line_length
            Self.logger.error("failed fetching company \(id, privacy: .public): \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return company
    }

}
