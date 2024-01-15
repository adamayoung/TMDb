import Foundation

///
/// Provides an interface for obtaining company data from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class CompanyService {

    private let apiClient: any APIClient

    ///
    /// Creates a company service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: some APIClient) {
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
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching company.
    ///
    public func details(forCompany id: Company.ID) async throws -> Company {
        let company: Company
        do {
            company = try await apiClient.get(endpoint: CompanyEndpoint.details(companyID: id))
        } catch let error {
            throw TMDbError(error: error)
        }

        return company
    }

}
