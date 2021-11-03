import Foundation

/// A pageable list of items.
public struct PageableListResult<Result: Decodable & Identifiable & Equatable & Hashable>: Decodable, Equatable,
                                                                                           Hashable {

    /// Page number.
    public let page: Int?
    /// Results for this page of a list.
    public let results: [Result]
    /// Total results.
    public let totalResults: Int?
    /// Total pages.
    public let totalPages: Int?

    /// Creates a new `PageableListResult`.
    ///
    /// - Parameters:
    ///    - page: Page number.
    ///    - results: Results for this page of a list.
    ///    - totalResults: Total results.
    ///    - totalPages: Total pages.
    public init(page: Int? = 1, results: [Result], totalResults: Int? = 0, totalPages: Int? = 0) {
        self.page = page
        self.results = results
        self.totalResults = totalResults
        self.totalPages = totalPages
    }

}
