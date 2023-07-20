import Foundation

///
/// Provides an interface for obtaining company data from TMDb.
///
public final class CompanyService {

    private let apiClient: APIClient

    ///
    /// Creates a company service object.
    ///
    /// - Parameters:
    ///    - config: TMDb configuration setting.
    ///
    public convenience init(config: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(apiKey: config.apiKey)
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
        try await apiClient.get(endpoint: CompanyEndpoint.details(companyID: id))
    }

}
