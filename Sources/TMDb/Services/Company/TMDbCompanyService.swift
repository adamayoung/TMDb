import Foundation

final class TMDbCompanyService: CompanyService {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func details(forCompany id: Company.ID) async throws -> Company {
        try await apiClient.get(endpoint: CompanyEndpoint.details(companyID: id))
    }

}
