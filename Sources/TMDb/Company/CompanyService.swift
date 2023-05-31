import Foundation

public final class CompanyService {

    private let apiClient: APIClient

    public convenience init(config: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(apiKey: config.apiKey)
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns TV shows to be discovered.
    ///
    /// [TMDb API - Companies: Details](https://developers.themoviedb.org/3/companies/get-company-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the company.
    ///
    /// - Returns: Matching company.
    ///
    public func details(forCompany id: Company.ID) async throws -> Company {
        try await apiClient.get(endpoint: CompanyEndpoint.details(companyID: id))
    }

}
