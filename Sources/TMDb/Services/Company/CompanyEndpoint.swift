import Foundation

enum CompanyEndpoint {

    case details(companyID: Company.ID)

}

extension CompanyEndpoint: Endpoint {

    private static let basePath = URL(string: "/company")!

    var path: URL {
        switch self {
        case .details(let companyID):
            return Self.basePath
                .appendingPathComponent(companyID)
        }
    }

}
