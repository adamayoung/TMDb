import Foundation

/// A service to fetch details about companies.
public protocol CompanyService {

    /// Returns TV shows to be discovered.
    ///
    /// [TMDb API - Companies: Details](https://developers.themoviedb.org/3/companies/get-company-details)
    ///
    /// - Parameters:
    ///     - id: The identifier of the company.
    ///
    /// - Returns: Matching company.
    func details(forCompany id: Company.ID) async throws -> Company

}
